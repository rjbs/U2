use strict;
use warnings;
use Test::More 'no_plan';

use U2;

sub uri_is {
  my ($struct, $uri) = @_;
  my $str = U2->from_struct($struct);
  is($str, $uri, "correctly produced $uri");
}

uri_is(
  {
    scheme    => 'http',
    authority => {
      hostname => 'example.com',
      port     => '8080',
    },
    path      => [ qw(~rjbs rfc 3986) ],
    query     => { format => 'text', section => [ 1, 2 ] },
    fragment  => 'foo'
  },
  'http://example.com:8080/~rjbs/rfc/3986?format=text;section=1;section=2#foo',
);

