use strict;
use warnings;
use Test::More 'no_plan';

use U2;

sub uri_is {
  my ($uri, $struct) = @_;

  if ($struct) {
    my $str = U2->from_struct($struct);
    is($str, $uri, "produced $uri");
  } else {
    TODO: {
      local $TODO = "not yet implemented";
      fail("produced $uri");
    }
  }
}

my @tests = (
  [
    'http://example.com:8080/~rjbs/rfc/3986?format=text;sec=1;sec=2#foo',
    {
      scheme    => 'http',
      authority => {
        hostname => 'example.com',
        port     => '8080',
      },
      path      => [ qw(~rjbs rfc 3986) ],
      query     => [ 
        [ format => 'text'  ],
        [ sec    => 1       ],
        [ sec    => 2       ],
      ],
      fragment  => 'foo'
    },
  ],

  [ 'http://example.com'                    ],
  [ 'http://example.com:80'                 ],
  [ 'http://example.com/'                   ],
  [ 'http://example.com/foo'                ],
  [ 'http://example.com/foo//'              ],
  [ 'http://example.com/foo/./bar'          ],
  [ 'http://example.com/foo/../bar'         ],
  [ 'http://example.com/#fragment'          ],
  [ 'http://example.com/?bar=1;foo=2'       ],
  [ 'http://example.com/?foo=1;bar=2'       ],
  [ 'http://example.com/?foo=1&bar=2'       ],
  [ 'http://example.com/?bar=1;bar=2;foo=2' ],
  [ 'http://example.com/?bar=1;bar=1;foo=2' ],
  [ 'http://example.com/?bar=2;bar=1;foo=2' ],
  [ 'http://example.com/?bar=1;foo=2;bar=3' ],
  [ 'http://example.com/?keyword'           ],
  [ 'http://example.com/?k1+k2+k3'          ],

  [ 'mailto:rjbs@example.com'               ],
  [ 'tag:codesimply.com,2008:rx/core/int'   ],
);

for my $test (@tests) {
  uri_is($test->[0], $test->[1]);
}

