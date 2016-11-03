package Dracilious;
use Mojo::Base 'Mojolicious';

sub startup {
  my $self = shift;

  my $r = $self->routes;
  # Normal route to controller
  $r->get('/')->to('Api#home');
  $r->post('/auth')->to('Api#authenticate');
  $r->post('/loaddata')->to('Api#loaddata');
  $r->get('/loginform')->to('Api#loginform');

}

1;
