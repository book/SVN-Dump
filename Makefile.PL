use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'SVN::Dump',
    VERSION_FROM => 'lib/SVN/Dump.pm',
    PREREQ_PM    => {
        'Test::More'     => 0,
    },
    PL_FILES => {},
    ABSTRACT_FROM => 'lib/SVN/Dump.pm',
    AUTHOR        => 'Philippe "BooK" Bruhat <book@cpan.org>',
);
