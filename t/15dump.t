use Test::More;
use strict;
use warnings;
use File::Spec::Functions;
use SVN::Dump;

plan tests => 5;

# non-existing dumpfile
eval { my $dump = SVN::Dump->new( { file => 'krunch' } ); };
like( $@, qr/^Can't open krunch: /, "new() fails with non-existing file" );

# try an existing one, now
my $dump = SVN::Dump->new(
    { file => catfile( qw( t dump full test123-r0.svn) ) } );

is( $dump->version(), '', 'No dump format version yet' );
$dump->next_record();
is( $dump->version(), '2', 'Read dump format version' );

is( $dump->uuid(), '', 'No UUID yet' );
$dump->next_record();
is( $dump->uuid(), '2785358f-ed1c-0410-8d81-93a2a39f1216', 'Read UUID' );

