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
my $control_dump = $3; $control_dump = strip( $control_dump );
my $control_text = $4; $control_text = strip( $control_text );
my $control_xml  = $5; $control_xml  = strip( $control_xml );
my $control_html = $6; $control_html = strip( $control_html );

ok( show( process_hand( $raw, ) )                      eq $control_dump, 'Output format - Dump' );
ok( show( process_hand( $raw, 0 ), '2P2',  'show', 1 ) eq $control_2p2,  'Output format - 2P2' );
ok( show( process_hand( $raw, 0 ), 'text', 'show', 1 ) eq $control_text, 'Output format - Text' );
ok( show( process_hand( $raw, 0 ), 'xml',  'show', 1 ) eq $control_xml,  'Output format - XML' );
ok( show( process_hand( $raw, 0 ), 'html', 'show', 1 ) eq $control_html, 'Output format - HTML' );


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
Compliments of [url=http://pokergeek.com/cgi-bin/handconverter/convert.cgi]PokerGeek[/url]
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

[b]Flop:[/b] (2.60 SB) 6:spade:, 7:diamond:, 9:club: [color:#0000FF](3 players)[/color]
Hero checks, Big blind checks, CO checks

[b]Turn:[/b] (1.30 BB) T:heart: [color:#0000FF](3 players)[/color]
Hero checks, Big blind bets, CO folds, Hero calls

[b]River:[/b] (3.30 BB) 5:heart: [color:#0000FF](2 players)[/color]
Hero checks, Big blind checks

[b]Final Pot:[/b] $34 ($1 rake)

Results below:
Small blind has Ad 3h Qc Kh (HI: high card Ace; LO: 7,6,5,3,A)

Outcome: Hero wins $17
Outcome: Hero wins $17
END_2P2
START_DUMP
$VAR1 = {
          'bet_big' => '10',
          'players' => {
                         'Player_3' => {
                                         'position_name' => 'MP2',
                                         'stack' => '96',
                                         'seat' => '3'
                                       },
                         'Player_6' => {
                                         'position_name' => 'Button',
                                         'stack' => '209',
                                         'seat' => '6'
                                       },
                         'Player_5' => {
                                         'position_name' => 'CO',
                                         'stack' => '267.50',
                                         'seat' => '5'
                                       },
                         'Player_1' => {
                                         'position_name' => 'EP',
                                         'stack' => '72',
                                         'seat' => '1'
                                       },
                         'Player_4' => {
                                         'position_name' => 'LP',
                                         'stack' => '87',
                                         'seat' => '4'
                                       },
                         'Player_10' => {
                                          'position_name' => 'UTG+1',
                                          'stack' => '155',
                                          'seat' => '10'
                                        },
                         'Player_2' => {
                                         'position_name' => 'MP1',
                                         'stack' => '214',
                                         'seat' => '2'
                                       },
                         'Player_7' => {
                                         'position_name' => 'Small blind',
                                         'stack' => '183',
                                         'seat' => '7',
                                         'post_amount' => '2',
                                         'posted' => 'small blind',
                                         'final_hand' => 'HI: high card Ace; LO: 7,6,5,3,A',
                                         'cards' => 'Ad 3h Qc Kh',
                                         'hand' => 'Ad 3h Qc Kh',
                                         'is_hero' => 1,
                                         'pots' => [
                                                     {
                                                       'amount' => '17',
                                                       'pot' => 'main'
                                                     },
                                                     {
                                                       'amount' => '17',
                                                       'pot' => 'main'
                                                     }
                                                   ]
                                       },
                         'Player_8' => {
                                         'post_amount' => 5,
                                         'position_name' => 'Big blind',
                                         'posted' => 'big blind',
                                         'stack' => '226',
                                         'seat' => '8'
                                       },
                         'Player_9' => {
                                         'position_name' => 'UTG',
                                         'stack' => '450',
                                         'seat' => '9'
                                       }
                       },
          'game_display' => 'Omaha/8',
          'hand_id' => '0000000000',
          'bb_size' => '5',
          'potsize' => {
                         'river' => '3.30 BB',
                         'turn' => '1.30 BB',
                         'showdown' => '3.30 BB',
                         'flop' => '2.60 SB'
                       },
          'stakes' => '$5/$10',
          'stakes_desc' => 'Stakes',
          'symbol' => '$',
          'active_players' => 10,
          'rake' => '1',
          'board' => {
                       'river' => '5h',
                       'turn' => 'Th',
                       'flop' => '6s,7d,9c'
                     },
          'bet_small' => '5',
          'site' => 'PokerStars',
          'structure' => 'Limit',
          'game' => 'OH',
          'action' => {
                        'river' => 'Player_7 checks/Player_8 checks',
                        'turn' => 'Player_7 checks/Player_8 bets $10/Player_5 folds/Player_7 calls $10',
                        'flop' => 'Player_7 checks/Player_8 checks/Player_5 checks',
                        'preflop' => 'Player_9 folds/Player_10 folds/Player_1 folds/Player_2 folds/Player_3 folds/Player_4 folds/Player_5 calls $5/Player_6 folds/Player_7 calls $3/Player_8 checks'
                      },
          'type' => 'Ring',
          'button' => 6,
          'hilo_flag' => 1
        };
END_DUMP
START_TEXT
PokerStars $5/$10 Limit Omaha/8 Ring  (10 handed)

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

Preflop: Hero is Small blind with Ad, 3h, Qc, Kh.
6 folds, CO calls, 1 fold, Hero calls, Big blind checks

Flop: (2.60 SB) 6s (3 players)
Hero checks, Big blind checks, CO checks

Turn: (1.30 BB) Th (3 players)
Hero checks, Big blind bets, CO folds, Hero calls

River: (3.30 BB) 5h (2 players)
Hero checks, Big blind checks

Final Pot: $34 ($1 rake)

Results below:
Small blind has Ad 3h Qc Kh (HI: high card Ace; LO: 7,6,5,3,A)
Outcome: Hero wins $17
Outcome: Hero wins $17
END_TEXT
START_XML
<?xml version='1.0' standalone='yes'?>
<HandHistory active_players="10" bb_size="5" bet_big="10" bet_small="5" button="6" game="OH" game_display="Omaha/8" hand_id="0000000000" hilo_flag="1" rake="1" site="PokerStars" stakes="$5/$10" stakes_desc="Stakes" structure="Limit" symbol="$" type="Ring">
  <action flop="Player_7 checks/Player_8 checks/Player_5 checks" preflop="Player_9 folds/Player_10 folds/Player_1 folds/Player_2 folds/Player_3 folds/Player_4 folds/Player_5 calls $5/Player_6 folds/Player_7 calls $3/Player_8 checks" river="Player_7 checks/Player_8 checks" turn="Player_7 checks/Player_8 bets $10/Player_5 folds/Player_7 calls $10" />
  <board flop="6s,7d,9c" river="5h" turn="Th" />
  <players ="Player_1" position_name="EP" seat="1" stack="72" />
  <players ="Player_10" position_name="UTG+1" seat="10" stack="155" />
  <players ="Player_2" position_name="MP1" seat="2" stack="214" />
  <players ="Player_3" position_name="MP2" seat="3" stack="96" />
  <players ="Player_4" position_name="LP" seat="4" stack="87" />
  <players ="Player_5" position_name="CO" seat="5" stack="267.50" />
  <players ="Player_6" position_name="Button" seat="6" stack="209" />
  <players ="Player_7" cards="Ad 3h Qc Kh" final_hand="HI: high card Ace; LO: 7,6,5,3,A" hand="Ad 3h Qc Kh" is_hero="1" position_name="Small blind" post_amount="2" posted="small blind" seat="7" stack="183">
    <pots amount="17" pot="main" />
    <pots amount="17" pot="main" />
  </players>
  <players ="Player_8" position_name="Big blind" post_amount="5" posted="big blind" seat="8" stack="226" />
  <players ="Player_9" position_name="UTG" seat="9" stack="450" />
  <potsize flop="2.60 SB" river="3.30 BB" showdown="3.30 BB" turn="1.30 BB" />
</HandHistory>
END_XML
START_HTML
PokerStars $5/$10 Omaha/8 (10 handed)&#60;br&#62;
&#60;br&#62;
Starting Stacks&#60;br&#62;
Seat 1: EP ($72)&#60;br&#62;
Seat 2: MP1 ($214)&#60;br&#62;
Seat 3: MP2 ($96)&#60;br&#62;
Seat 4: LP ($87)&#60;br&#62;
Seat 5: CO ($267.50)&#60;br&#62;
Seat 6: Button ($209)&#60;br&#62;
Seat 7: Small blind (Hero) ($183)&#60;br&#62;
Seat 8: Big blind ($226)&#60;br&#62;
Seat 9: UTG ($450)&#60;br&#62;
Seat 10: UTG+1 ($155)&#60;br&#62;
&#60;br&#62;
&#60;strong&#62;Preflop:&#60;/strong&#62; Hero is Small blind with Ad, 3h, Qc, Kh.&#60;br&#62;
&#60;font color="#666666"&#62;&#60;em&#62;6 folds&#60;/em&#62;&#60;/font&#62;, CO calls, &#60;font color="#666666"&#62;&#60;em&#62;1 fold&#60;/em&#62;&#60;/font&#62;, Small blind calls, Big blind checks&#60;br&#62;
&#60;br&#62;
&#60;strong&#62;Flop:&#60;/strong&#62; (2.60 SB) 6s &#60;font color="#0000FF"&#62;(3 players)&#60;/font&#62;&#60;br&#62;
Small blind checks, Big blind checks, CO checks&#60;br&#62;
&#60;br&#62;
&#60;strong&#62;Turn:&#60;/strong&#62; (1.30 BB) Th &#60;font color="#0000FF"&#62;(3 players)&#60;/font&#62;&#60;br&#62;
Small blind checks, Big blind bets, CO folds, Small blind calls&#60;br&#62;
&#60;br&#62;
&#60;strong&#62;River:&#60;/strong&#62; (3.30 BB) 5h &#60;font color="#0000FF"&#62;(2 players)&#60;/font&#62;&#60;br&#62;
Small blind checks, Big blind checks&#60;br&#62;
&#60;br&#62;
&#60;strong&#62;Final Pot:&#60;/strong&#62; 3.30 BB&#60;br&#62;
&#60;br&#62;
Results in white below:&#60;br&#62;
&#60;font color="#FFFFFF"&#62;Small blind has Ad 3h Qc Kh (HI: high card Ace; LO: 7,6,5,3,A)&#60;br&#62;
Outcome: Small blind wins $17&#60;br&#62;
Outcome: Small blind wins $17&#60;br&#62;
&#60;/font&#62;&#60;br&#62;
END_HTML