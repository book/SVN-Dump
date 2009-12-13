use Test::More;
use File::Find;

eval "use Test::Pod::Coverage 1.04";
plan skip_all => "Test::Pod::Coverage 1.04 required for testing POD coverage"
    if $@;

my @modules;
find( sub { push @modules, $File::Find::name if /\.pm$/ }, 'blib/lib' );

@modules = sort map { s!/!::!g; s/\.pm$//; s/^blib::lib:://; $_ } @modules;

plan tests => scalar @modules;

pod_coverage_ok($_) for grep { !/::Connector::/ } @modules;
pod_coverage_ok(
    $_,
    {   trustme =>
            [qr/^(?:listen|accept_from|connect|read_from|write_to|init)$/]
    }
    )
    for grep {/::Connector::/} @modules;

