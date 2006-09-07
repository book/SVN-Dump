use strict;
use warnings;
use Test::More;
use t::Utils;
use File::Spec::Functions;
use SVN::Dump::Reader;

my @files = glob catfile( 't', 'dump', 'headers', '*' );

plan tests => scalar @files;

for my $f (@files) {
    my $expected = file_content($f);
    open my $fh, $f or do {
        ok( 0, "Failed to open $f: $!" );
        next;
    };
    my $dump = SVN::Dump::Reader->new($fh);
    my $h    = $dump->read_header_block();

    is_same_string( $h->as_string(), $expected, "Read $f headers" );
}
