use strict;
use warnings;
use Test::More 'no_plan';

use U2;
use U2::Query::NamedParams;
use U2::Query::Keywords;

sub uri_is {
  my ($str, $struct) = @_;

  if ($struct) {
    my $uri = U2->from_struct($struct);
    is($uri->as_string, $str, "produced $str");
  } else {
    TODO: {
      local $TODO = "not yet implemented";
      fail("produced $str");
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

  [
    'http://example.com',
    {
      scheme    => 'http',
      authority => {
        hostname => 'example.com',
      },
    },
  ],

  [
    'http://example.com:80',
    {
      scheme    => 'http',
      authority => {
        hostname => 'example.com',
        port     => 80,
      },
    },
  ],

  [
    'http://example.com/',
    {
      scheme    => 'http',
      authority => {
        hostname => 'example.com',
      },
      path      => [ ],
    },
  ],

  [
    'http://example.com/foo',
    {
      scheme    => 'http',
      authority => {
        hostname => 'example.com',
      },
      path      => [ qw(foo) ],
    },
  ],

  [
    'http://example.com/foo/',
    {
      scheme    => 'http',
      authority => {
        hostname => 'example.com',
      },
      path      => [ qw(foo), '' ],
    },
  ],

  [
    'http://example.com/foo//',
    {
      scheme    => 'http',
      authority => {
        hostname => 'example.com',
      },
      path      => [ qw(foo), '', '' ],
    },
  ],

  [
    'http://example.com/foo/./bar',
    {
      scheme    => 'http',
      authority => {
        hostname => 'example.com',
      },
      path      => [ qw(foo), '.', 'bar' ],
    },
  ],

  [
    'http://example.com/foo/../bar',
    {
      scheme    => 'http',
      authority => {
        hostname => 'example.com',
      },
      path      => [ qw(foo), '..', 'bar' ],
    },
  ],

  [
    'http://example.com/#fragment',
    {
      scheme    => 'http',
      authority => {
        hostname => 'example.com',
      },
      path      => [ ],
      fragment  => 'fragment',
    },
  ],

  [
    'http://example.com?bar=1;foo=2',
    {
      scheme    => 'http',
      authority => {
        hostname => 'example.com',
      },
      query     => [
        [ bar => 1 ],
        [ foo => 2 ],
      ],
    },
  ],

  [
    'http://example.com/?bar=1;foo=2',
    {
      scheme    => 'http',
      authority => {
        hostname => 'example.com',
      },
      path      => [ ],
      query     => [
        [ bar => 1 ],
        [ foo => 2 ],
      ],
    },
  ],

  [
    'http://example.com/?foo=1;bar=2',
    {
      scheme    => 'http',
      authority => {
        hostname => 'example.com',
      },
      path      => [ ],
      query     => [
        [ foo => 1 ],
        [ bar => 2 ],
      ],
    },
  ],

  [
    'http://example.com/?foo=1&bar=2',
    {
      scheme    => 'http',
      authority => {
        hostname => 'example.com',
      },
      path      => [ ],
      query     => U2::Query::NamedParams->new(
        [
          [ foo => 1 ],
          [ bar => 2 ],
        ],
        { delim => '&' },
      ),
    },
  ],

  [
    'http://example.com/?bar=1;bar=2;foo=2',
    {
      scheme    => 'http',
      authority => {
        hostname => 'example.com',
      },
      path      => [ ],
      query     => [
        [ bar => 1 ],
        [ bar => 2 ],
        [ foo => 2 ],
      ],
    },
  ],

  [
    'http://example.com/?bar=1;bar=1;foo=2',
    {
      scheme    => 'http',
      authority => {
        hostname => 'example.com',
      },
      path      => [ ],
      query     => [
        [ bar => 1 ],
        [ bar => 1 ],
        [ foo => 2 ],
      ],
    },
  ],

  [
    'http://example.com/?bar=2;bar=1;foo=2',
    {
      scheme    => 'http',
      authority => {
        hostname => 'example.com',
      },
      path      => [ ],
      query     => [
        [ bar => 2 ],
        [ bar => 1 ],
        [ foo => 2 ],
      ],
    },
  ],

  [
    'http://example.com/?bar=1;foo=2;bar=3',
    {
      scheme    => 'http',
      authority => {
        hostname => 'example.com',
      },
      path      => [ ],
      query     => [
        [ bar => 1 ],
        [ foo => 2 ],
        [ bar => 3 ],
      ],
    },
  ],

  [
    'http://example.com/?keyword',
    {
      scheme    => 'http',
      authority => {
        hostname => 'example.com',
      },
      path      => [ ],
      query     => U2::Query::Keywords->new([ qw(keyword) ]),
    },
  ],

  [
    'http://example.com/?k1+k2+k3',
    {
      scheme    => 'http',
      authority => {
        hostname => 'example.com',
      },
      path      => [ ],
      query     => U2::Query::Keywords->new([ qw(k1 k2 k3) ]),
    },
  ],

  [
    'mailto:rjbs@example.com',
    {
      scheme   => 'mailto',
      path     => [ 'rjbs@example.com' ],
      relative => 1,
    }
  ],

  [
    'tag:codesimply.com,2008:rx/core/int',
    {
      scheme   => 'tag',
      path     => [ 'codesimply.com,2008:rx', 'core', 'int' ],
      relative => 1,
    }
  ],
);

for my $test (@tests) {
  uri_is($test->[0], $test->[1]);
}

