use strict;
use warnings;
package U2::Query::NamedParams;

use Scalar::Util ();

sub new {
  my ($class, $struct) = @_;
  
  if (Scalar::Util::reftype($struct) eq 'HASH') {
    my @new;
    for my $key (keys %$struct) {
      my $val = ref $struct->{$key} ? $struct->{$key} : [ $struct->{$key} ];
      push @new, map {; [ $key => $_ ] } @$val;
    }
    $struct = \@new;
  } else {
    # XXX: assume it's okay for now -- rjbs, 2009-04-06
  }

  bless { pairs => $struct } => $class;
}

sub as_string {
  my ($self) = @_;
  join q{;}, map {; "$_->[0]=$_->[1]" } @{ $self->{pairs} };
}

1;
