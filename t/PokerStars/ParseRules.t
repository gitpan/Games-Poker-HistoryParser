#!perl

use Test::More qw( no_plan );

use Data::Dumper;

BEGIN {
    use_ok( 'Games::Poker::HistoryParser::Sites::PokerStars::ParseRules' );
}

can_ok( Games::Poker::HistoryParser::Sites::PokerStars::ParseRules, qw( get_rules )  );
ok( ref get_rules( 'he' ) eq 'HASH', 'Parsing rules hash exist for Hold\'em' );
ok( ref get_rules( 'oh' ) eq 'HASH', 'Parsing rules hash exist for Omaha' );