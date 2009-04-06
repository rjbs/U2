use strict;
use warnings;
package U2;
# ABSTRACT: the URI library you've been looking for

sub from_struct {
  my ($self, $s) = @_;

  sprintf '%s://%s%s%s%s',
    $s->{scheme},
    sprintf('%s:%s', $s->{authority}{hostname}, $s->{authority}{port}),
    ($s->{path} ? ('/' . join('/', @{ $s->{path} })) : ''),
    (defined $s->{query} ? ('?' . $self->_query_str($s->{query})) : ''),
    (defined $s->{fragment} ? "#$s->{fragment}" : '');
}

sub _query_str {
  my ($self, $query) = @_;

  my @hunks;
  for my $key (keys %$query) {
    my $vals = ref $query->{$key} ? $query->{$key} : [ $query->{$key} ];
    push @hunks, map { "$key=$_" } @$vals;
  }

  join q{;}, @hunks;
}

1;
