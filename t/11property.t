use strict;
use warnings;
use Test::More;
use t::Utils;

use SVN::Dump::Property;

my @tests = (
    [ bloop  => 'zwapp' ],
    [ zap    => 'glipp' ],
    [ bap    => 'kapow' ],
    [ thwapp => 'owww' ],
);

# the 
my $as_string = << 'END_OF_PROPERTY';
K 5
bloop
V 5
zwapp
K 3
zap
V 5
glipp
K 3
bap
V 5
kapow
K 6
thwapp
V 4
owww
PROPS-END

END_OF_PROPERTY

plan tests => 13 + 2 * @tests;

#
my $p = SVN::Dump::Property->new();
isa_ok( $p, 'SVN::Dump::Property' );

# try setting some values
for my $kv (@tests) {
    is( $p->set(@$kv), $kv->[1], "Set $kv->[0] => $kv->[1]" );
    is( $p->get($kv->[0]), $kv->[1], "Get $kv->[0] as $kv->[1]" );
}

# check the order of the keys
is_deeply( [ $p->keys() ],   [ map { $_->[0] } @tests ], "Keys in order" );
is_deeply( [ $p->values() ], [ map { $_->[1] } @tests ], "Values in order" );

# check the string serialisation
is_same_string( $p->as_string(), $as_string, 'Property serialisation' );

# change a value
is( $p->set( bap => 'urkkk' ), 'urkkk', "Changed 'bap' value" );
is( $p->get('bap'), 'urkkk', "Really changed 'bap' value" );

# check the order
$tests[2] = [ bap => 'urkkk' ];
is_deeply( [ $p->keys() ],   [ map { $_->[0] } @tests ], "Keys in order" );
is_deeply( [ $p->values() ], [ map { $_->[1] } @tests ], "Values in order" );

# add a new key
is( $p->set( swish => 'ker_sploosh' ), 'ker_sploosh', "Added 'swish' value" );
is( $p->get('swish'), 'ker_sploosh', "Really added 'swish' value" );

# check the order again
push @tests, [swish => 'ker_sploosh' ];
is_deeply( [ $p->keys() ],   [ map { $_->[0] } @tests ], "Keys in order" );
is_deeply( [ $p->values() ], [ map { $_->[1] } @tests ], "Values in order" );

# 
$as_string =~ s/kapow/urkkk/; # same length
$as_string =~ s/PROPS-END/K 5\012swish\012V 11\012ker_sploosh\012PROPS-END/;

is_same_string( $p->as_string(), $as_string, 'Property serialisation' );

