use strict;
use warnings;
use Test::More;
use t::Utils;
use File::Spec::Functions;
use SVN::Dump::Reader;

my @files = glob catfile( 't', 'dump', 'records', '*' );

plan tests => scalar @files;

for my $f (@files) {
    my $expected = file_content($f);
    open my $fh, $f or do {
        ok( 0, "Failed to open $f: $!" );
        next;
    };

    my $dump = SVN::Dump::Reader->new($fh);
    my $r    = $dump->read_record();
    is_same_string( $r->as_string(), $expected, "Read $f record" );
}

