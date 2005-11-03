use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Games::Poker::HistoryParser',
    AUTHOR              => 'Troy Denkinger <perl@pokergeek.com>',
    VERSION_FROM        => 'lib/Games/Poker/HistoryParser/Sites/Sites.pm',
    ABSTRACT            => 'lib/Games/Poker/HistoryParser/Sites/Sites.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'HistoryParser-*' },
);
