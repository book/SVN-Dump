use strict;
use warnings;
use Test::More;
use List::Util 'shuffle';

use SVN::Dump::Headers;

my @valid = (
    [ 'Revision-number'     => 1 ],
    [ 'Prop-content-length' => 125 ],
    [ 'Content-length'      => 125 ],
);

plan tests => 11 + 2 * @valid;

my $h = SVN::Dump::Headers->new();

isa_ok( $h, 'SVN::Dump::Headers' );

eval { $h->type() };
like( $@, qr/^Unable to determine the record type/, 'No type yet (type)' );

eval { $h->keys() };
like( $@, qr/^Unable to determine the record type/, 'No type yet (keys)' );

# test the set/get methods
is( $h->set( Zlonk => 'Kapow' ), 'Kapow', 'set() returns the new value' );
is( $h->get('Zlonk'), 'Kapow', 'get() method returns the value' );
is( $h->get('Vronk'), undef, 'get() returns undef for non-existent header' );
is( $h->set( Bam_Kapow => 'Zowie' ), 'Zowie', 'set() returns the new value' );
is( $h->get( 'Bam-Kapow' ), 'Zowie', '_ and - work the same' );
is( $h->get( 'Bam_Kapow' ), 'Zowie', '_ and - work the same' );

eval { $h->keys() };
like( $@, qr/^Unable to determine the record type/, 'No type yet (keys)' );

my $c = 0;
for my $p (@valid) {
    is( $h->set(@$p), $p->[1],
        "set() method returns the new value for $p->[0]" );
    $c++;
    is( scalar $h->keys(), $c, "$c valid keys" );
}
is_deeply(
    [ $h->keys() ],
    [ map { $_->[0] } @valid ],
    'keys() return the valid keys in order'
);

