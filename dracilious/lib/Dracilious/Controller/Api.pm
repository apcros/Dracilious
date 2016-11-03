package Dracilious::Controller::Api;

use Carp;
use DracPerl::Client;
use File::Slurp qw(read_file write_file);
use HTTP::Cookies;
use JSON;
use Mojo::Base 'Mojolicious::Controller';
use Moose;

has 'drac' => ( is => 'rw', lazy => 1, builder => '_build_drac' );
has 'cfg'  => ( is => 'ro', lazy => 1, builder => '_build_cfg' );

sub _build_cfg {
    my ($self) = @_;
    my $json_raw = read_file(".cfg");
    return decode_json($json_raw);
}

sub _build_drac {
    my ($self) = @_;

    my $user = $self->cfg->{user} || Carp::croak("Missing user in .cfg");
    my $password
        = $self->cfg->{password} || Carp::croak("Missing password in .cfg");
    my $dracip = $self->cfg->{ip} || Carp::croak("Missing ip in .cfg");

    my $drac
        = DracPerl::Client->new(
        { user => $user, password => $password, url => "https://" . $dracip }
        );
    return $drac;

}

sub _load_or_open_session {
    my ($self) = @_;
    my $token  = read_file(".token");
    my $cookie = read_file(".cookies");

    $self->_open_and_save_session() unless $token;

    my $cookies = HTTP::Cookies->new();
    $cookies->set_cookie( 0, "_appwebSessionId_", $cookie, "/",
        $self->cfg->{ip}, undef, 1, 1, undef, 1 );
    my $session;
    $session->{cookie_jar} = $cookies;
    $session->{token}      = $token;
    $self->drac->openSession($session);

    $self->_open_and_save_session() unless $self->drac->isAlive();
}

sub _open_and_save_session {
    my ($self) = @_;
    $self->drac->openSession();
    my $saved_session = $self->drac->saveSession();

    my $cookie_jar
        = $self->drac->ua->cookie_jar;    #TODO bug to fix in Drac-Perl
    my $cookie = $cookie_jar->{COOKIES}->{ $self->cfg->{ip} }->{'/'}
        ->{'_appwebSessionId_'}[1];

    write_file( ".token",   $saved_session->{token} );
    write_file( ".cookies", $cookie );
}

sub loaddata {
    my $self = shift;
    my $type = $self->param("type") || "summary";
    $self->_load_or_open_session();

    my $xml
        = $self->drac->get(
        "pwState,sysDesc,sysRev,hostName,osName,osVersion,svcTag,expSvcCode,biosVer,fwVersion,LCCfwVersion"
        );
    $self->render( xml => $xml, template => 'api/summary' );
}

sub summary {
    my $self = shift;

}

sub home {
    my $self = shift;
    $self->render();
}

1;
