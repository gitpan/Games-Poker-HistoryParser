#!perl

use Test::More qw( no_plan );

use Data::Dumper;

BEGIN {
    use_ok( 'Games::Poker::HistoryParser::Sites::Sites' );
}

can_ok( Games::Poker::HistoryParser::Sites::Sites, qw( process_hand )  );
ok( ! defined process_hand( 'foo', 0 ), 'Unimplemented site' );