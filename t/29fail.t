use strict;
use Test::More;
use File::Spec::Functions;
use SVN::Dump::Reader;

my @files = glob catfile( 't', 'dump', 'fail', '*' );

plan tests => 2 * @files;

for my $f (@files) {
    open my $fh, $f or do {
        fail("Failed to open $f: $!") for 1 .. 2;
        next;
    };

    # read the test information from the test file itself
    my $func = <$fh>; # first line contains the method name
    my $err  = <$fh>; # second line contains the error regexp
    chop $func;
    chop $err;

    my $r = SVN::Dump::Reader->new($fh);
    eval { $r->$func(); };
    isnt( $@, '', "$func() failed for $f" );
    like( $@, qr/$err/, "  with the expected error ($err)" );
}

