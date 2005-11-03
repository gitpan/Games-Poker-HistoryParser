#!perl


use Test::More tests => 6;

BEGIN {
    use_ok( 'Games::Poker::HistoryParser::Sites::Common' );
}

can_ok( Games::Poker::HistoryParser::Sites::Common, qw( position_names rounds )  );

my @positions = qw( CO LP MP2 MP1 UTG+1 UTG BB SB );
is_deeply( \@positions, Games::Poker::HistoryParser::Sites::Common::position_names( 'HE', 9 ), 'Position names' );
ok( ! defined Games::Poker::HistoryParser::Sites::Common::position_names( 'FOO', 9 ), 'Position names - Bad game' );

my @rounds = qw( Third Fourth Fifth Sixth River );
is_deeply( \@rounds, Games::Poker::HistoryParser::Sites::Common::rounds( 'ST' ), 'Rounds' );
ok( ! defined Games::Poker::HistoryParser::Sites::Common::rounds( 'FOO' ), 'Rounds - Bad game' );
