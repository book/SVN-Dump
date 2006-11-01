use strict;
use warnings;
use Test::More;

use SVN::Dump::Headers;

plan tests => 5;

my $h = SVN::Dump::Headers->new();

isa_ok( $h, 'SVN::Dump::Headers' );

eval { $h->type() };
like( $@, qr/^Unable to determine the record type/, 'No type yet' );

# test the set/get methods
is( $h->set( Zlonk => 'Kapow' ), 'Kapow', 'set() returns the new value' );
is( $h->get( 'Zlonk' ), 'Kapow', 'get() method returns the value' );
is( $h->get( 'Vronk' ), undef, 'get() returns undef for non-existent header');
