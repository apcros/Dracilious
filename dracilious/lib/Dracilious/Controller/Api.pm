package Dracilious::Controller::Api;
use Mojo::Base 'Mojolicious::Controller';
use Moose;
use DracPerl::Client;

has 'drac' => (is => 'ro', lazy => 1, builder => '_build_api_client');

sub _build_api_client {
	my $self = shift;
	return DracPerl::Client->new({user => 'user', password => 'password', url => 'url'});
}

sub summary {
  my $self = shift;
  my $xml = $self->drac->get("pwState,sysDesc,sysRev,hostName,osName,osVersion,svcTag,expSvcCode,biosVer,fwVersion,LCCfwVersion");
  $self->render(xml => $xml);
}

1;
