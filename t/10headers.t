use strict;
use warnings;
use Test::More;

use SVN::Dump::Headers;

plan tests => 2;

my $h = SVN::Dump::Headers->new();

isa_ok( $h, 'SVN::Dump::Headers' );

eval { $h->type() };
like( $@, qr/^Unable to determine the record type/, 'No type yet' );

