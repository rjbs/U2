use strict;
use warnings;
package U2;
# ABSTRACT: the URI library you've been looking for

use U2::Query::NamedParams;

sub from_struct {
  my ($self, $s) = @_;

  my $query;
  $query = U2::Query::NamedParams->new($s->{query}) if defined $s->{query};

  sprintf '%s://%s%s%s%s',
    $s->{scheme},
    sprintf('%s:%s', $s->{authority}{hostname}, $s->{authority}{port}),
    ($s->{path} ? ('/' . join('/', @{ $s->{path} })) : ''),
    (defined $query ? ('?' . $query->as_string) : ''),
    (defined $s->{fragment} ? "#$s->{fragment}" : '');
}

1;
