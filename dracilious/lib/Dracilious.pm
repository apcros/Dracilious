package Dracilious;
use Mojo::Base 'Mojolicious';

sub startup {
  my $self = shift;

  my $r = $self->routes;
  # Normal route to controller
  $r->get('/')->to('Api#summary');
}

1;
