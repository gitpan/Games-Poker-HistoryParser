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
***** Hand History for Game 2981408939 *****
$25 PL Omaha - Friday, November 04, 19:47:52 EDT 2005
Table Table  64984 (Real Money)
Seat 7 is the button
Total number of players : 10 
Seat 1: JHENF ( $4.70 )
Seat 4: Robcsi111 ( $30.85 )
Seat 5: susSums ( $24.75 )
Seat 6: PRAISEJESUS ( $17.55 )
Seat 7: GRAY48 ( $56.82 )
Seat 2: BrainerdBun ( $18.50 )
Seat 8: Acetylcholin ( $10.10 )
Seat 10: Urponaattori ( $40.95 )
Seat 9: FFFEMI ( $26.20 )
Seat 3: jmiquel1 ( $25 )
Acetylcholin posts small blind [$0.10].
FFFEMI posts big blind [$0.25].
jmiquel1 is sitting out.
** Dealing down cards **
Dealt to BrainerdBun [  8d 5s 4s 6s ]
Urponaattori folds.
JHENF calls [$0.25].
BrainerdBun calls [$0.25].
Robcsi111 folds.
susSums folds.
PRAISEJESUS calls [$0.25].
GRAY48 folds.
Acetylcholin calls [$0.15].
FFFEMI checks.
** Dealing Flop ** [ 7d, 5h, 3c ]
Acetylcholin checks.
FFFEMI checks.
JHENF checks.
BrainerdBun bets [$1.20].
PRAISEJESUS calls [$1.20].
Acetylcholin folds.
FFFEMI folds.
JHENF folds.
** Dealing Turn ** [ 6d ]
BrainerdBun bets [$3.50].
PRAISEJESUS raises [$14].
BrainerdBun is all-In  [$13.55]
PRAISEJESUS is all-In  [$2.10]
** Dealing River ** [ Tc ]
PRAISEJESUS shows [ 5d, 4c, 7c, 9h ] a straight, three to seven.
BrainerdBun shows [ 8d, 5s, 4s, 6s ] a straight, four to eight.
BrainerdBun wins $0.95 from  side pot #1  with a straight, four to eight.
BrainerdBun wins $34.10 from  the main pot  with a straight, four to eight.
END_RAW
START_2P2
Compliments of [url=http://pokergeek.com/cgi-bin/handconverter/convert.cgi]PokerGeek[/url]
PartyPoker PL Omaha High Ring - 0.10/0.25 Blinds  (9 handed)

Starting Stacks
Seat 1: UTG+1 ($4.70)
Seat 2: MP1 (Hero) ($18.50)
Seat 4: MP2 ($30.85)
Seat 5: LP ($24.75)
Seat 6: CO ($17.55)
Seat 7: Button ($56.82)
Seat 8: Small blind ($10.10)
Seat 9: Big blind ($26.20)
Seat 10: UTG ($40.95)

[b]Preflop:[/b] Hero is MP1 with 8:diamond:, 5:spade:, 4:spade:, 6:spade:.
[color:#666666][i]1 fold[/i][/color], UTG+1 calls ($025), Hero calls ($025), [color:#666666][i]2 folds[/i][/color], CO calls ($025), [color:#666666][i]1 fold[/i][/color], Small blind calls ($015), Big blind checks

[b]Flop:[/b] ($90.25) 7:diamond:, 5:heart:, 3:club: [color:#0000FF](5 players)[/color]
Small blind checks, Big blind checks, UTG+1 checks, Hero bets ($120), CO calls ($120), Small blind folds, Big blind folds, UTG+1 folds

[b]Turn:[/b] ($330.25) 6:diamond: [color:#0000FF](2 players)[/color]
Hero bets ($350), CO raises ($14), Hero all-in ($1355), CO all-in ($210)

[b]River:[/b] ($694.25) T:club: [color:#0000FF](0 players)[/color]


[b]Final Pot:[/b] $35.05 ($0 rake)

Results below:
MP1 has 8d 5s 4s 6s (a straight, four to eight)
CO has 5d 4c 7c 9h (a straight, three to seven)

Outcome: Hero wins $0.95 from side pot
Outcome: Hero wins $34.10 from main pot
END_2P2
START_DUMP
$VAR1 = {
          'bet_big' => 1,
          'players' => {
                         'Urponaattori' => {
                                             'position_name' => 'UTG',
                                             'stack' => '40.95',
                                             'seat' => '10'
                                           },
                         'FFFEMI' => {
                                       'post_amount' => '0.25',
                                       'position_name' => 'Big blind',
                                       'posted' => 'big blind',
                                       'stack' => '26.20',
                                       'seat' => '9'
                                     },
                         'GRAY48' => {
                                       'position_name' => 'Button',
                                       'stack' => '56.82',
                                       'seat' => '7'
                                     },
                         'JHENF' => {
                                      'position_name' => 'UTG+1',
                                      'stack' => '4.70',
                                      'seat' => '1'
                                    },
                         'BrainerdBun' => {
                                            'position_name' => 'MP1',
                                            'final_hand' => 'a straight, four to eight',
                                            'stack' => '18.50',
                                            'is_hero' => 1,
                                            'hand' => '8d 5s 4s 6s',
                                            'cards' => '8d 5s 4s 6s',
                                            'seat' => '2',
                                            'pots' => [
                                                        {
                                                          'amount' => '0.95',
                                                          'pot' => 'side'
                                                        },
                                                        {
                                                          'amount' => '34.10',
                                                          'pot' => 'main'
                                                        }
                                                      ]
                                          },
                         'Robcsi111' => {
                                          'position_name' => 'MP2',
                                          'stack' => '30.85',
                                          'seat' => '4'
                                        },
                         'Acetylcholin' => {
                                             'post_amount' => '0.10',
                                             'position_name' => 'Small blind',
                                             'posted' => 'small blind',
                                             'stack' => '10.10',
                                             'seat' => '8'
                                           },
                         'PRAISEJESUS' => {
                                            'position_name' => 'CO',
                                            'final_hand' => 'a straight, three to seven',
                                            'stack' => '17.55',
                                            'cards' => '5d 4c 7c 9h',
                                            'seat' => '6'
                                          },
                         'susSums' => {
                                        'position_name' => 'LP',
                                        'stack' => '24.75',
                                        'seat' => '5'
                                      }
                       },
          'game_display' => 'Omaha High',
          'hand_id' => '2981408939',
          'bb_size' => '0.25',
          'sb_size' => '0.10',
          'potsize' => {
                         'river' => '$694.25',
                         'turn' => '$330.25',
                         'showdown' => '$694.25',
                         'flop' => '$90.25'
                       },
          'stakes_desc' => 'Blinds',
          'stakes' => '0.10/0.25',
          'symbol' => '$',
          'active_players' => 9,
          'rake' => 0,
          'board' => {
                       'river' => ' Tc ',
                       'turn' => ' 6d ',
                       'flop' => '7d,5h,3c'
                     },
          'bet_small' => 1,
          'site' => 'PartyPoker',
          'structure' => 'PL',
          'game' => 'OH',
          'action' => {
                        'river' => '',
                        'turn' => 'BrainerdBun bets $350/PRAISEJESUS raises $14/BrainerdBun all-in $1355/PRAISEJESUS all-in $210',
                        'flop' => 'Acetylcholin checks/FFFEMI checks/JHENF checks/BrainerdBun bets $120/PRAISEJESUS calls $120/Acetylcholin folds/FFFEMI folds/JHENF folds',
                        'preflop' => 'Urponaattori folds/JHENF calls $025/BrainerdBun calls $025/Robcsi111 folds/susSums folds/PRAISEJESUS calls $025/GRAY48 folds/Acetylcholin calls $015/FFFEMI checks'
                      },
          'type' => 'Ring',
          'button' => 7,
          'sidepot_flag' => 1,
          'hilo_flag' => 0
        };
END_DUMP
START_TEXT
PartyPoker 0.10/0.25 PL Omaha High Ring  (9 handed)

Starting Stacks
Seat 1: UTG+1 ($4.70)
Seat 2: MP1 (Hero) ($18.50)
Seat 4: MP2 ($30.85)
Seat 5: LP ($24.75)
Seat 6: CO ($17.55)
Seat 7: Button ($56.82)
Seat 8: Small blind ($10.10)
Seat 9: Big blind ($26.20)
Seat 10: UTG ($40.95)

Preflop: Hero is MP1 with 8d, 5s, 4s, 6s.
1 fold, UTG+1 calls ($025), Hero calls ($025), 2 folds, CO calls ($025), 1 fold, Small blind calls ($015), Big blind checks

Flop: ($90.25) 7d (5 players)
Small blind checks, Big blind checks, UTG+1 checks, Hero bets ($120), CO calls ($120), Small blind folds, Big blind folds, UTG+1 folds

Turn: ($330.25) 6d (2 players)
Hero bets ($350), CO raises ($14), Hero all-in ($1355), CO all-in ($210)

River: ($694.25) Tc (0 players)


Final Pot: $35.05 ($0 rake)

Results below:
MP1 has 8d 5s 4s 6s (a straight, four to eight)
CO has 5d 4c 7c 9h (a straight, three to seven)
Outcome: Hero wins $0.95 from side pot
Outcome: Hero wins $34.10 from main pot
END_TEXT
START_XML
<?xml version='1.0' standalone='yes'?>
<HandHistory active_players="9" bb_size="0.25" bet_big="1" bet_small="1" button="7" game="OH" game_display="Omaha High" hand_id="2981408939" hilo_flag="0" rake="0" sb_size="0.10" sidepot_flag="1" site="PartyPoker" stakes="0.10/0.25" stakes_desc="Blinds" structure="PL" symbol="$" type="Ring">
  <action flop="Acetylcholin checks/FFFEMI checks/JHENF checks/BrainerdBun bets $120/PRAISEJESUS calls $120/Acetylcholin folds/FFFEMI folds/JHENF folds" preflop="Urponaattori folds/JHENF calls $025/BrainerdBun calls $025/Robcsi111 folds/susSums folds/PRAISEJESUS calls $025/GRAY48 folds/Acetylcholin calls $015/FFFEMI checks" river="" turn="BrainerdBun bets $350/PRAISEJESUS raises $14/BrainerdBun all-in $1355/PRAISEJESUS all-in $210" />
  <board flop="7d,5h,3c" river=" Tc " turn=" 6d " />
  <players ="Acetylcholin" position_name="Small blind" post_amount="0.10" posted="small blind" seat="8" stack="10.10" />
  <players ="BrainerdBun" cards="8d 5s 4s 6s" final_hand="a straight, four to eight" hand="8d 5s 4s 6s" is_hero="1" position_name="MP1" seat="2" stack="18.50">
    <pots amount="0.95" pot="side" />
    <pots amount="34.10" pot="main" />
  </players>
  <players ="FFFEMI" position_name="Big blind" post_amount="0.25" posted="big blind" seat="9" stack="26.20" />
  <players ="GRAY48" position_name="Button" seat="7" stack="56.82" />
  <players ="JHENF" position_name="UTG+1" seat="1" stack="4.70" />
  <players ="PRAISEJESUS" cards="5d 4c 7c 9h" final_hand="a straight, three to seven" position_name="CO" seat="6" stack="17.55" />
  <players ="Robcsi111" position_name="MP2" seat="4" stack="30.85" />
  <players ="Urponaattori" position_name="UTG" seat="10" stack="40.95" />
  <players ="susSums" position_name="LP" seat="5" stack="24.75" />
  <potsize flop="$90.25" river="$694.25" showdown="$694.25" turn="$330.25" />
</HandHistory>
END_XML
START_HTML
PartyPoker 0.10/0.25 Omaha High (9 handed)&#60;br&#62;
&#60;br&#62;
Starting Stacks&#60;br&#62;
Seat 1: UTG+1 ($4.70)&#60;br&#62;
Seat 2: MP1 (Hero) ($18.50)&#60;br&#62;
Seat 4: MP2 ($30.85)&#60;br&#62;
Seat 5: LP ($24.75)&#60;br&#62;
Seat 6: CO ($17.55)&#60;br&#62;
Seat 7: Button ($56.82)&#60;br&#62;
Seat 8: Small blind ($10.10)&#60;br&#62;
Seat 9: Big blind ($26.20)&#60;br&#62;
Seat 10: UTG ($40.95)&#60;br&#62;
&#60;br&#62;
&#60;strong&#62;Preflop:&#60;/strong&#62; Hero is MP1 with 8d, 5s, 4s, 6s.&#60;br&#62;
&#60;font color="#666666"&#62;&#60;em&#62;1 fold&#60;/em&#62;&#60;/font&#62;, UTG+1 calls, MP1 calls, &#60;font color="#666666"&#62;&#60;em&#62;2 folds&#60;/em&#62;&#60;/font&#62;, CO calls, &#60;font color="#666666"&#62;&#60;em&#62;1 fold&#60;/em&#62;&#60;/font&#62;, Small blind calls, Big blind checks&#60;br&#62;
&#60;br&#62;
&#60;strong&#62;Flop:&#60;/strong&#62; ($90.25) 7d &#60;font color="#0000FF"&#62;(5 players)&#60;/font&#62;&#60;br&#62;
Small blind checks, Big blind checks, UTG+1 checks, MP1 bets, CO calls, Small blind folds, Big blind folds, UTG+1 folds&#60;br&#62;
&#60;br&#62;
&#60;strong&#62;Turn:&#60;/strong&#62; ($330.25) 6d &#60;font color="#0000FF"&#62;(2 players)&#60;/font&#62;&#60;br&#62;
MP1 bets, CO raises, MP1 all-in, CO all-in&#60;br&#62;
&#60;br&#62;
&#60;strong&#62;River:&#60;/strong&#62; ($694.25) Tc &#60;font color="#0000FF"&#62;(0 players)&#60;/font&#62;&#60;br&#62;
&#60;br&#62;
&#60;br&#62;
&#60;strong&#62;Final Pot:&#60;/strong&#62; $694.25&#60;br&#62;
&#60;br&#62;
Results in white below:&#60;br&#62;
&#60;font color="#FFFFFF"&#62;MP1 has 8d 5s 4s 6s (a straight, four to eight)&#60;br&#62;
CO has 5d 4c 7c 9h (a straight, three to seven)&#60;br&#62;
Outcome: MP1 wins $0.95 from side pot&#60;br&#62;
Outcome: MP1 wins $34.10 from main pot&#60;br&#62;
&#60;/font&#62;&#60;br&#62;
END_HTML