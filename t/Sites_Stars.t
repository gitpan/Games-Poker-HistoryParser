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
Compliments of [url=http://pokergeek.com/cgi-bin/handconverter/convert.cgi]PokerGeek[/url]
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
$VAR1 = {
          'bet_big' => '1.00',
          'players' => {
                         'Player_3' => {
                                         'position_name' => 'UTG+1',
                                         'stack' => '15',
                                         'seat' => '3'
                                       },
                         'Player_6' => {
                                         'position_name' => 'MP2',
                                         'stack' => '22.25',
                                         'seat' => '6'
                                       },
                         'Player_5' => {
                                         'position_name' => 'MP1',
                                         'stack' => '42.75',
                                         'seat' => '5'
                                       },
                         'Player_1' => {
                                         'post_amount' => '0.50',
                                         'position_name' => 'Big blind',
                                         'posted' => 'big blind',
                                         'stack' => '18.75',
                                         'is_hero' => 1,
                                         'hand' => '7s As',
                                         'seat' => '1'
                                       },
                         'Player_4' => {
                                         'position_name' => 'EP',
                                         'stack' => '27.75',
                                         'seat' => '4'
                                       },
                         'Player_10' => {
                                          'post_amount' => '0.25',
                                          'position_name' => 'Small blind',
                                          'posted' => 'small blind',
                                          'stack' => '3.75',
                                          'seat' => '10'
                                        },
                         'Player_2' => {
                                         'position_name' => 'UTG',
                                         'stack' => '60.25',
                                         'seat' => '2'
                                       },
                         'Player_7' => {
                                         'position_name' => 'LP',
                                         'stack' => '21.25',
                                         'seat' => '7'
                                       },
                         'Player_8' => {
                                         'position_name' => 'CO',
                                         'stack' => '24.75',
                                         'seat' => '8'
                                       },
                         'Player_9' => {
                                         'position_name' => 'Button',
                                         'final_hand' => 'a pair of Queens',
                                         'stack' => '11.75',
                                         'cards' => 'Qc Qd',
                                         'seat' => '9',
                                         'pots' => [
                                                     {
                                                       'amount' => '7',
                                                       'pot' => 'main'
                                                     }
                                                   ]
                                       }
                       },
          'game_display' => 'Hold\'em',
          'hand_id' => '0000000000',
          'bb_size' => '0.50',
          'potsize' => {
                         'river' => '5.25 BB',
                         'turn' => '3.25 BB',
                         'showdown' => '7.25 BB',
                         'flop' => '4.50 SB'
                       },
          'stakes' => '$0.50/$1.00',
          'stakes_desc' => 'Stakes',
          'symbol' => '$',
          'active_players' => 10,
          'rake' => '0.25',
          'board' => {
                       'river' => '9s',
                       'turn' => '8h',
                       'flop' => '5s,7h,3h'
                     },
          'bet_small' => '0.50',
          'site' => 'PokerStars',
          'structure' => 'Limit',
          'game' => 'HE',
          'action' => {
                        'river' => 'Player_1 checks/Player_9 bets $1/Player_1 calls $1',
                        'turn' => 'Player_1 checks/Player_9 bets $1/Player_1 calls $1',
                        'flop' => 'Player_1 checks/Player_9 bets $0.50/Player_1 calls $0.50',
                        'preflop' => 'Player_2 folds/Player_3 folds/Player_4 folds/Player_5 folds/Player_6 folds/Player_7 folds/Player_8 folds/Player_9 raises $1/Player_10 folds/Player_1 calls $0.50'
                      },
          'type' => 'Ring',
          'button' => 9,
          'hilo_flag' => 0
        };
END_DUMP
START_TEXT
PokerStars $0.50/$1.00 Limit Hold'em Ring  (10 handed)

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

Preflop: Hero is Big blind with 7s, As.
7 folds, Button raises, Small blind folds, Hero calls

Flop: (4.50 SB) 5s (2 players)
Hero checks, Button bets, Hero calls

Turn: (3.25 BB) 8h (2 players)
Hero checks, Button bets, Hero calls

River: (5.25 BB) 9s (2 players)
Hero checks, Button bets, Hero calls

Final Pot: $7 ($0.25 rake)

Results below:
Button has Qc Qd (a pair of Queens)
Outcome: Button wins $7
END_TEXT
START_XML
<?xml version='1.0' standalone='yes'?>
<HandHistory active_players="10" bb_size="0.50" bet_big="1.00" bet_small="0.50" button="9" game="HE" game_display="Hold'em" hand_id="0000000000" hilo_flag="0" rake="0.25" site="PokerStars" stakes="$0.50/$1.00" stakes_desc="Stakes" structure="Limit" symbol="$" type="Ring">
  <action flop="Player_1 checks/Player_9 bets $0.50/Player_1 calls $0.50" preflop="Player_2 folds/Player_3 folds/Player_4 folds/Player_5 folds/Player_6 folds/Player_7 folds/Player_8 folds/Player_9 raises $1/Player_10 folds/Player_1 calls $0.50" river="Player_1 checks/Player_9 bets $1/Player_1 calls $1" turn="Player_1 checks/Player_9 bets $1/Player_1 calls $1" />
  <board flop="5s,7h,3h" river="9s" turn="8h" />
  <players ="Player_1" hand="7s As" is_hero="1" position_name="Big blind" post_amount="0.50" posted="big blind" seat="1" stack="18.75" />
  <players ="Player_10" position_name="Small blind" post_amount="0.25" posted="small blind" seat="10" stack="3.75" />
  <players ="Player_2" position_name="UTG" seat="2" stack="60.25" />
  <players ="Player_3" position_name="UTG+1" seat="3" stack="15" />
  <players ="Player_4" position_name="EP" seat="4" stack="27.75" />
  <players ="Player_5" position_name="MP1" seat="5" stack="42.75" />
  <players ="Player_6" position_name="MP2" seat="6" stack="22.25" />
  <players ="Player_7" position_name="LP" seat="7" stack="21.25" />
  <players ="Player_8" position_name="CO" seat="8" stack="24.75" />
  <players ="Player_9" cards="Qc Qd" final_hand="a pair of Queens" position_name="Button" seat="9" stack="11.75">
    <pots amount="7" pot="main" />
  </players>
  <potsize flop="4.50 SB" river="5.25 BB" showdown="7.25 BB" turn="3.25 BB" />
</HandHistory>
END_XML
START_HTML
PokerStars $0.50/$1.00 Hold'em (10 handed)&#60;br&#62;
&#60;br&#62;
Starting Stacks&#60;br&#62;
Seat 1: Big blind (Hero) ($18.75)&#60;br&#62;
Seat 2: UTG ($60.25)&#60;br&#62;
Seat 3: UTG+1 ($15)&#60;br&#62;
Seat 4: EP ($27.75)&#60;br&#62;
Seat 5: MP1 ($42.75)&#60;br&#62;
Seat 6: MP2 ($22.25)&#60;br&#62;
Seat 7: LP ($21.25)&#60;br&#62;
Seat 8: CO ($24.75)&#60;br&#62;
Seat 9: Button ($11.75)&#60;br&#62;
Seat 10: Small blind ($3.75)&#60;br&#62;
&#60;br&#62;
&#60;strong&#62;Preflop:&#60;/strong&#62; Hero is Big blind with 7s, As.&#60;br&#62;
&#60;font color="#666666"&#62;&#60;em&#62;7 folds&#60;/em&#62;&#60;/font&#62;, Button raises, Small blind folds, Big blind calls&#60;br&#62;
&#60;br&#62;
&#60;strong&#62;Flop:&#60;/strong&#62; (4.50 SB) 5s &#60;font color="#0000FF"&#62;(2 players)&#60;/font&#62;&#60;br&#62;
Big blind checks, Button bets, Big blind calls&#60;br&#62;
&#60;br&#62;
&#60;strong&#62;Turn:&#60;/strong&#62; (3.25 BB) 8h &#60;font color="#0000FF"&#62;(2 players)&#60;/font&#62;&#60;br&#62;
Big blind checks, Button bets, Big blind calls&#60;br&#62;
&#60;br&#62;
&#60;strong&#62;River:&#60;/strong&#62; (5.25 BB) 9s &#60;font color="#0000FF"&#62;(2 players)&#60;/font&#62;&#60;br&#62;
Big blind checks, Button bets, Big blind calls&#60;br&#62;
&#60;br&#62;
&#60;strong&#62;Final Pot:&#60;/strong&#62; 7.25 BB&#60;br&#62;
&#60;br&#62;
Results in white below:&#60;br&#62;
&#60;font color="#FFFFFF"&#62;Button has Qc Qd (a pair of Queens)&#60;br&#62;
Outcome: Button wins $7&#60;br&#62;
&#60;/font&#62;&#60;br&#62;
END_HTML