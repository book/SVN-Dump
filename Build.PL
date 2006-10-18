use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'SVN::Dump',
    license             => 'perl',
    dist_author         => 'Philippe "BooK" Bruhat <book@cpan.org>',
    dist_version_from   => 'lib/SVN/Dump.pm',
    requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'SVN-Dump-*' ],
);

$builder->create_build_script();
