use strict;
use warnings;
package U2::Query::Keywords;

use Scalar::Util ();

sub new {
  my ($class, $struct, $arg) = @_;
  $arg ||= {};

  bless {
    keywords => $struct,
  } => $class;
}

sub as_string {
  my ($self) = @_;
  join q{+}, @{ $self->{keywords} };
}

1;
