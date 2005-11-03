#!perl

use Test::More qw( no_plan );

use Data::Dumper;

BEGIN {
    use_ok( 'Games::Poker::HistoryParser::Sites::Sites' );
    use Games::Poker::HistoryParser::Output::Output;
}

can_ok( Games::Poker::HistoryParser::Sites::Sites, qw( process_hand )  );
ok( ! defined process_hand( 'foo', 0 ), 'Unimplemented site' );

my $data;
{
	local $/;
	$data = <DATA>;
}

$data =~ m/START_RAW(.+?)END_RAW.*
           START_2P2(.+?)END_2P2.*
           START_DUMP(.+?)END_DUMP.*
           START_TEXT(.+?)END_TEXT.*
           START_XML(.+?)END_XML.*
           START_HTML(.+?)END_HTML.*
          /sx;

my $raw          = $1;
my $control_2p2  = $2; $control_2p2  = strip( $control_2p2 );
#my $control_dump = $3; $control_dump = strip( $control_dump );
#my $control_text = $4; $control_text = strip( $control_text );
#my $control_xml  = $5; $control_xml  = strip( $control_xml );
#my $control_html = $6; $control_html = strip( $control_html );

#ok( show( process_hand( $raw, ) )                      eq $control_dump, 'Output format - Dump' );
ok( show( process_hand( $raw, 0 ), '2P2',  'show', 1 ) eq $control_2p2,  'Output format - 2P2' );
#ok( show( process_hand( $raw, 0 ), 'text', 'show', 1 ) eq $control_text, 'Output format - Text' );
#ok( show( process_hand( $raw, 0 ), 'xml',  'show', 1 ) eq $control_xml,  'Output format - XML' );
#ok( show( process_hand( $raw, 0 ), 'html', 'show', 1 ) eq $control_html, 'Output format - HTML' );


sub strip{
	my ( $string ) = @_;
	
	$string =~ s/\s+$//;
	$string =~ s/^\s+//;
	
	return $string;
}

__DATA__
START_RAW
PokerStars Game #0000000000:  Hold'em Limit ($0.50/$1.00) - 2005/07/27 - 18:54:16 (ET)
Table 'Nerthus' Seat #9 is the button
Seat 1: Player_1 ($18.75 in chips) 
Seat 2: Player_2 ($60.25 in chips) 
Seat 3: Player_3 ($15 in chips) 
Seat 4: Player_4 ($27.75 in chips) 
Seat 5: Player_5 ($42.75 in chips) 
Seat 6: Player_6 ($22.25 in chips) 
Seat 7: Player_7 ($21.25 in chips) 
Seat 8: Player_8 ($24.75 in chips) 
Seat 9: Player_9 ($11.75 in chips) 
Seat 10: Player_10 ($3.75 in chips) 
Player_10: posts small blind $0.25
Player_1: posts big blind $0.50
*** HOLE CARDS ***
Dealt to Player_1 [7s As]
Player_2: folds 
Player_3: folds 
Player_4: folds 
Player_5: folds 
Player_6: folds 
Player_7: folds 
Player_8: folds 
Player_9: raises $0.50 to $1
Player_10: folds 
Player_1: calls $0.50
*** FLOP *** [5s 7h 3h]
Player_1: checks 
Player_9: bets $0.50
Player_1: calls $0.50
*** TURN *** [5s 7h 3h] [8h]
Player_1: checks 
Player_9: bets $1
Player_1: calls $1
*** RIVER *** [5s 7h 3h 8h] [9s]
Player_1: checks 
Player_9: bets $1
Player_1: calls $1
*** SHOW DOWN ***
Player_9: shows [Qc Qd] (a pair of Queens)
Player_1: mucks hand 
Player_9 collected $7 from pot
*** SUMMARY ***
Total pot $7.25 | Rake $0.25 
Board [5s 7h 3h 8h 9s]
Seat 1: Player_1 (big blind) mucked [7s As]
Seat 2: Player_2 folded before Flop (didn't bet)
Seat 3: Player_3 folded before Flop (didn't bet)
Seat 4: Player_4 folded before Flop (didn't bet)
Seat 5: Player_5 folded before Flop (didn't bet)
Seat 6: Player_6 folded before Flop (didn't bet)
Seat 7: Player_7 folded before Flop (didn't bet)
Seat 8: Player_8 folded before Flop (didn't bet)
Seat 9: Player_9 (button) showed [Qc Qd] and won ($7) with a pair of Queens
Seat 10: Player_10 (small blind) folded before Flop
END_RAW
START_2P2
PokerStars Limit Hold'em Ring - $0.50/$1.00 Stakes  (10 handed)

Starting Stacks
Seat 1: Big blind (Hero) ($18.75)
Seat 2: UTG ($60.25)
Seat 3: UTG+1 ($15)
Seat 4: EP ($27.75)
Seat 5: MP1 ($42.75)
Seat 6: MP2 ($22.25)
Seat 7: LP ($21.25)
Seat 8: CO ($24.75)
Seat 9: Button ($11.75)
Seat 10: Small blind ($3.75)

[b]Preflop:[/b] Hero is Big blind with 7:spade:, A:spade:.
[color:#666666][i]7 folds[/i][/color], Button raises, Small blind folds, Hero calls

[b]Flop:[/b] (4.50 SB) 5:spade:, 7:heart:, 3:heart: [color:#0000FF](2 players)[/color]
Hero checks, Button bets, Hero calls

[b]Turn:[/b] (3.25 BB) 8:heart: [color:#0000FF](2 players)[/color]
Hero checks, Button bets, Hero calls

[b]River:[/b] (5.25 BB) 9:spade: [color:#0000FF](2 players)[/color]
Hero checks, Button bets, Hero calls

[b]Final Pot:[/b] $7 ($0.25 rake)

Results below:
Button has Qc Qd (a pair of Queens)
Outcome: Button wins $7
END_2P2
START_DUMP
END_DUMP
START_TEXT
END_TEXT
START_XML
END_XML
START_HTML
END_HTML