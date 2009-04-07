use strict;
use warnings;
package U2;
# ABSTRACT: the URI library you've been looking for

use Scalar::Util ();

use U2::Query::NamedParams;

sub from_struct {
  my ($self, $s) = @_;

  my $query;
  if (defined $s->{query}) {
    $query = Scalar::Util::blessed($s->{query})
           ? $s->{query}
           : U2::Query::NamedParams->new($s->{query});
  }

  sprintf '%s:%s%s%s%s',
    $s->{scheme},
    ($s->{authority}
      ? sprintf(
          '//%s%s',
          $s->{authority}{hostname},
          (defined $s->{authority}{port} ? ":$s->{authority}{port}" : '')
        )
      : ''
    ),
    ($s->{path}
      ? (($s->{relative} ? '' : '/') . join('/', @{ $s->{path} }))
      : ''
    ),
    (defined $query ? ('?' . $query->as_string) : ''),
    (defined $s->{fragment} ? "#$s->{fragment}" : '');
}

1;
