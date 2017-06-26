use strict;
use warnings;
package U2;
# ABSTRACT: the URI library you've been looking for

use Scalar::Util ();

use U2::Query::NamedParams;

sub from_struct {
  my ($class, $s) = @_;

  bless $s => $class;
}

sub from_string {
  my ($class, $str) = @_;
  
  $str =~ m{\A(\w+):([^?]*)(?:\?([^#]*))?(?:#(.+))?\z};

  my %arg = (
    scheme => $1,
    hier   => $2,
    query  => $3,
    frag   => $4,
  );

  if ($arg{hier} =~ m{\A//(?:([^@]+)@)?([^:]*?)(?::(\d+))?(/.+)?\z}) {
    $arg{authority} = {
      userinfo => $1,
      host     => $2,
      port     => $3,
    };

    $arg{path} = [ split m{/}, $4 ];

    if (@{ $arg{path} } and $arg{path}[0] eq '') {
      shift @{ $arg{path} };
    } else {
      $arg{relative} = 1;
    }
  }

  use YAML::XS;
  warn Dump(\%arg);
}

sub as_string {
  my ($self) = @_;

  my $query;
  if (defined $self->{query}) {
    $query = Scalar::Util::blessed($self->{query})
           ? $self->{query}
           : U2::Query::NamedParams->new($self->{query});
  }

  sprintf '%s:%s%s%s%s',
    $self->{scheme},
    ($self->{authority}
      ? sprintf(
          '//%s%s',
          $self->{authority}{hostname},
          (defined $self->{authority}{port} ? ":$self->{authority}{port}" : '')
        )
      : ''
    ),
    ($self->{path}
      ? (($self->{relative} ? '' : '/') . join('/', @{ $self->{path} }))
      : ''
    ),
    (defined $query ? ('?' . $query->as_string) : ''),
    (defined $self->{fragment} ? "#$self->{fragment}" : '');
}

1;
