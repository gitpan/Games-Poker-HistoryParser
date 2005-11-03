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
PokerStars Game #0000000000:  Omaha Hi/Lo Limit ($5/$10) - 2005/08/21 - 21:44:08 (ET)
Table 'Sualocin' Seat #6 is the button
Seat 1: Player_1 ($72 in chips)
Seat 2: Player_2 ($214 in chips)
Seat 3: Player_3 ($96 in chips)
Seat 4: Player_4 ($87 in chips)
Seat 5: Player_5 ($267.50 in chips)
Seat 6: Player_6 ($209 in chips)
Seat 7: Player_7 ($183 in chips)
Seat 8: Player_8 ($226 in chips)
Seat 9: Player_9 ($450 in chips)
Seat 10: Player_10 ($155 in chips)
Player_7: posts small blind $2
Player_8: posts big blind $5
*** HOLE CARDS ***
Dealt to Player_7 [Ad 3h Qc Kh]
Player_9: folds
Player_10: folds
Player_1: folds
Player_2: folds
Player_3: folds
Player_4: folds
Player_5: calls $5
Player_6: folds
Player_7: calls $3
Player_8: checks
*** FLOP *** [6s 7d 9c]
Player_7: checks
Player_8: checks
Player_5: checks
*** TURN *** [6s 7d 9c] [Th]
Player_7: checks
Player_8: bets $10
Player_5: folds
Player_7: calls $10
*** RIVER *** [6s 7d 9c Th] [5h]
Player_7: checks
Player_8: checks
*** SHOW DOWN ***
Player_7: shows [Ad 3h Qc Kh] (HI: high card Ace; LO: 7,6,5,3,A)
Player_8: mucks hand
Player_7 collected $17 from pot
Player_7 collected $17 from pot
*** SUMMARY ***
Total pot $35 | Rake $1
Board [6s 7d 9c Th 5h]
Seat 1: Player_1 folded before Flop (didn't bet)
Seat 2: Player_2 folded before Flop (didn't bet)
Seat 3: Player_3 folded before Flop (didn't bet)
Seat 4: Player_4 folded before Flop (didn't bet)
Seat 5: Player_5 folded on the Turn
Seat 6: Player_6 (button) folded before Flop (didn't bet)
Seat 7: Player_7 (small blind) showed [Ad 3h Qc Kh] and won ($34) 
with HI: high card Ace; LO: 7,6,5,3,A
Seat 8: Player_8 (big blind) mucked [2h Kc 3c Jh]
Seat 9: Player_9 folded before Flop (didn't bet)
Seat 10: Player_10 folded before Flop (didn't bet)
END_RAW
START_2P2
PokerStars Limit Omaha/8 Ring - $5/$10 Stakes  (10 handed)

Starting Stacks
Seat 1: EP ($72)
Seat 2: MP1 ($214)
Seat 3: MP2 ($96)
Seat 4: LP ($87)
Seat 5: CO ($267.50)
Seat 6: Button ($209)
Seat 7: Small blind (Hero) ($183)
Seat 8: Big blind ($226)
Seat 9: UTG ($450)
Seat 10: UTG+1 ($155)

[b]Preflop:[/b] Hero is Small blind with A:diamond:, 3:heart:, Q:club:, K:heart:.
[color:#666666][i]6 folds[/i][/color], CO calls, [color:#666666][i]1 fold[/i][/color], Hero calls, Big blind checks

[b]Flop:[/b] (3.00 SB) 6:spade:, 7:diamond:, 9:club: [color:#0000FF](3 players)[/color]
Hero checks, Big blind checks, CO checks

[b]Turn:[/b] (1.50 BB) T:heart: [color:#0000FF](3 players)[/color]
Hero checks, Big blind bets, CO folds, Hero calls

[b]River:[/b] (3.50 BB) 5:heart: [color:#0000FF](2 players)[/color]
Hero checks, Big blind checks

[b]Final Pot:[/b] $34 ($1 rake)

Results below:
Small blind has Ad 3h Qc Kh (HI: high card Ace; LO: 7,6,5,3,A)
Outcome: Hero wins $17
Outcome: Hero wins $17
END_2P2
START_DUMP
END_DUMP
START_TEXT
END_TEXT
START_XML
END_XML
START_HTML
END_HTML