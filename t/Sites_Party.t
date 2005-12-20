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
#Game No : 0000000000 
***** Hand History for Game 0000000000 *****
$2/$4 Hold'em - Sunday, May 22, 23:23:09 EDT 2005
Table Bad Beat Jackpot #1000000 (Real Money)
Seat 10 is the button
Total number of players : 9 
Seat 1: Player_1 ( $152 )
Seat 4: Player_4 ( $39.5 )
Seat 5: Player_5 ( $83 )
Seat 6: Player_6 ( $104 )
Seat 7: Player_7 ( $30.5 )
Seat 8: Player_8 ( $35.08 )
Seat 9: Player_9 ( $16 )
Seat 3: Player_3 ( $100 )
Seat 10: Player_10 ( $96 )
Player_1 posts small blind [$1].
Player_4 posts big blind [$2].
** Dealing down cards **
Dealt to Player_10 [  4d 6d ]
Player_5 folds.
Player_6 calls [$2].
Player_7 folds.
Player_8 folds.
Player_9 folds.
Player_10 folds.
Player_1 calls [$1].
Player_4 checks.
** Dealing Flop ** [ 7d, 4h, 2s ]
Player_1 bets [$2].
Player_4 calls [$2].
Player_6 folds.
** Dealing Turn ** [ Ah ]
Player_1 checks.
Player_4 checks.
** Dealing River ** [ 6s ]
Player_1 checks.
Player_4 checks.
Player_1 shows [ Qh, Jd ] high card ace.
Player_4 shows [ 7c, Td ] a pair of sevens.
Player_4 wins $10 from  the main pot  with a pair of sevens.
END_RAW
START_2P2
Compliments of [url=http://pokergeek.com/cgi-bin/handconverter/convert.cgi]PokerGeek[/url]
PartyPoker Limit Hold'em Ring - $2/$4 Stakes  (8 handed)

Starting Stacks
Seat 1: Small blind ($152)
Seat 4: Big blind ($39.5)
Seat 5: UTG ($83)
Seat 6: UTG+1 ($104)
Seat 7: MP ($30.5)
Seat 8: LP ($35.08)
Seat 9: CO ($16)
Seat 10: Button (Hero) ($96)

[b]Preflop:[/b] Hero is Button with 4:diamond:, 6:diamond:.
[color:#666666][i]1 fold[/i][/color], UTG+1 calls, [color:#666666][i]4 folds[/i][/color], Small blind calls, Big blind checks

[b]Flop:[/b] (2.50 SB) 7:diamond:, 4:heart:, 2:spade: [color:#0000FF](3 players)[/color]
Small blind bets, Big blind calls, UTG+1 folds

[b]Turn:[/b] (2.25 BB) A:heart: [color:#0000FF](2 players)[/color]
Small blind checks, Big blind checks

[b]River:[/b] (2.25 BB) 6:spade: [color:#0000FF](2 players)[/color]
Small blind checks, Big blind checks

[b]Final Pot:[/b] $10 ($0 rake)

Results below:
Small blind has Qh Jd (high card ace)
Big blind has 7c Td (a pair of sevens)

Outcome: Big blind wins $10
END_2P2
START_DUMP
$VAR1 = {
          'bet_big' => '4',
          'players' => {
                         'Player_6' => {
                                         'position_name' => 'UTG+1',
                                         'stack' => '104',
                                         'seat' => '6'
                                       },
                         'Player_5' => {
                                         'position_name' => 'UTG',
                                         'stack' => '83',
                                         'seat' => '5'
                                       },
                         'Player_1' => {
                                         'post_amount' => '1',
                                         'position_name' => 'Small blind',
                                         'posted' => 'small blind',
                                         'final_hand' => 'high card ace',
                                         'stack' => '152',
                                         'cards' => 'Qh Jd',
                                         'seat' => '1'
                                       },
                         'Player_4' => {
                                         'position_name' => 'Big blind',
                                         'stack' => '39.5',
                                         'seat' => '4',
                                         'post_amount' => 2,
                                         'posted' => 'big blind',
                                         'final_hand' => 'a pair of sevens',
                                         'cards' => '7c Td',
                                         'pots' => [
                                                     {
                                                       'amount' => '10',
                                                       'pot' => 'main'
                                                     }
                                                   ]
                                       },
                         'Player_7' => {
                                         'position_name' => 'MP',
                                         'stack' => '30.5',
                                         'seat' => '7'
                                       },
                         'Player_10' => {
                                          'position_name' => 'Button',
                                          'stack' => '96',
                                          'is_hero' => 1,
                                          'hand' => '4d 6d',
                                          'seat' => '10'
                                        },
                         'Player_8' => {
                                         'position_name' => 'LP',
                                         'stack' => '35.08',
                                         'seat' => '8'
                                       },
                         'Player_9' => {
                                         'position_name' => 'CO',
                                         'stack' => '16',
                                         'seat' => '9'
                                       }
                       },
          'game_display' => 'Hold\'em',
          'hand_id' => '0000000000',
          'bb_size' => '2',
          'potsize' => {
                         'river' => '2.25 BB',
                         'turn' => '2.25 BB',
                         'showdown' => '2.25 BB',
                         'flop' => '2.50 SB'
                       },
          'stakes' => '$2/$4',
          'stakes_desc' => 'Stakes',
          'symbol' => '$',
          'active_players' => 8,
          'rake' => 0,
          'board' => {
                       'river' => ' 6s ',
                       'turn' => ' Ah ',
                       'flop' => '7d,4h,2s'
                     },
          'bet_small' => '2',
          'site' => 'PartyPoker',
          'structure' => 'Limit',
          'game' => 'HE',
          'action' => {
                        'river' => 'Player_1 checks/Player_4 checks',
                        'turn' => 'Player_1 checks/Player_4 checks',
                        'flop' => 'Player_1 bets $2/Player_4 calls $2/Player_6 folds',
                        'preflop' => 'Player_5 folds/Player_6 calls $2/Player_7 folds/Player_8 folds/Player_9 folds/Player_10 folds/Player_1 calls $1/Player_4 checks'
                      },
          'type' => 'Ring',
          'button' => 10,
          'hilo_flag' => 0
        };
END_DUMP
START_TEXT
PartyPoker $2/$4 Limit Hold'em Ring  (8 handed)

Starting Stacks
Seat 1: Small blind ($152)
Seat 4: Big blind ($39.5)
Seat 5: UTG ($83)
Seat 6: UTG+1 ($104)
Seat 7: MP ($30.5)
Seat 8: LP ($35.08)
Seat 9: CO ($16)
Seat 10: Button (Hero) ($96)

Preflop: Hero is Button with 4d, 6d.
1 fold, UTG+1 calls, 4 folds, Small blind calls, Big blind checks

Flop: (2.50 SB) 7d (3 players)
Small blind bets, Big blind calls, UTG+1 folds

Turn: (2.25 BB) Ah (2 players)
Small blind checks, Big blind checks

River: (2.25 BB) 6s (2 players)
Small blind checks, Big blind checks

Final Pot: $10 ($0 rake)

Results below:
Small blind has Qh Jd (high card ace)
Big blind has 7c Td (a pair of sevens)
Outcome: Big blind wins $10
END_TEXT
START_XML
<?xml version='1.0' standalone='yes'?>
<HandHistory active_players="8" bb_size="2" bet_big="4" bet_small="2" button="10" game="HE" game_display="Hold'em" hand_id="0000000000" hilo_flag="0" rake="0" site="PartyPoker" stakes="$2/$4" stakes_desc="Stakes" structure="Limit" symbol="$" type="Ring">
  <action flop="Player_1 bets $2/Player_4 calls $2/Player_6 folds" preflop="Player_5 folds/Player_6 calls $2/Player_7 folds/Player_8 folds/Player_9 folds/Player_10 folds/Player_1 calls $1/Player_4 checks" river="Player_1 checks/Player_4 checks" turn="Player_1 checks/Player_4 checks" />
  <board flop="7d,4h,2s" river=" 6s " turn=" Ah " />
  <players ="Player_1" cards="Qh Jd" final_hand="high card ace" position_name="Small blind" post_amount="1" posted="small blind" seat="1" stack="152" />
  <players ="Player_10" hand="4d 6d" is_hero="1" position_name="Button" seat="10" stack="96" />
  <players ="Player_4" cards="7c Td" final_hand="a pair of sevens" position_name="Big blind" post_amount="2" posted="big blind" seat="4" stack="39.5">
    <pots amount="10" pot="main" />
  </players>
  <players ="Player_5" position_name="UTG" seat="5" stack="83" />
  <players ="Player_6" position_name="UTG+1" seat="6" stack="104" />
  <players ="Player_7" position_name="MP" seat="7" stack="30.5" />
  <players ="Player_8" position_name="LP" seat="8" stack="35.08" />
  <players ="Player_9" position_name="CO" seat="9" stack="16" />
  <potsize flop="2.50 SB" river="2.25 BB" showdown="2.25 BB" turn="2.25 BB" />
</HandHistory>
END_XML
START_HTML
PartyPoker $2/$4 Hold'em (8 handed)&#60;br&#62;
&#60;br&#62;
Starting Stacks&#60;br&#62;
Seat 1: Small blind ($152)&#60;br&#62;
Seat 4: Big blind ($39.5)&#60;br&#62;
Seat 5: UTG ($83)&#60;br&#62;
Seat 6: UTG+1 ($104)&#60;br&#62;
Seat 7: MP ($30.5)&#60;br&#62;
Seat 8: LP ($35.08)&#60;br&#62;
Seat 9: CO ($16)&#60;br&#62;
Seat 10: Button (Hero) ($96)&#60;br&#62;
&#60;br&#62;
&#60;strong&#62;Preflop:&#60;/strong&#62; Hero is Button with 4d, 6d.&#60;br&#62;
&#60;font color="#666666"&#62;&#60;em&#62;1 fold&#60;/em&#62;&#60;/font&#62;, UTG+1 calls, &#60;font color="#666666"&#62;&#60;em&#62;4 folds&#60;/em&#62;&#60;/font&#62;, Small blind calls, Big blind checks&#60;br&#62;
&#60;br&#62;
&#60;strong&#62;Flop:&#60;/strong&#62; (2.50 SB) 7d &#60;font color="#0000FF"&#62;(3 players)&#60;/font&#62;&#60;br&#62;
Small blind bets, Big blind calls, UTG+1 folds&#60;br&#62;
&#60;br&#62;
&#60;strong&#62;Turn:&#60;/strong&#62; (2.25 BB) Ah &#60;font color="#0000FF"&#62;(2 players)&#60;/font&#62;&#60;br&#62;
Small blind checks, Big blind checks&#60;br&#62;
&#60;br&#62;
&#60;strong&#62;River:&#60;/strong&#62; (2.25 BB) 6s &#60;font color="#0000FF"&#62;(2 players)&#60;/font&#62;&#60;br&#62;
Small blind checks, Big blind checks&#60;br&#62;
&#60;br&#62;
&#60;strong&#62;Final Pot:&#60;/strong&#62; 2.25 BB&#60;br&#62;
&#60;br&#62;
Results in white below:&#60;br&#62;
&#60;font color="#FFFFFF"&#62;Small blind has Qh Jd (high card ace)&#60;br&#62;
Big blind has 7c Td (a pair of sevens)&#60;br&#62;
Outcome: Big blind wins $10&#60;br&#62;
&#60;/font&#62;&#60;br&#62;
END_HTML