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

#ok( show( process_hand( $raw, ) )                      eq $control_dump, 'Output format - Dump' );
#ok( show( process_hand( $raw, 0 ), '2P2',  'show', 1 ) eq $control_2p2,  'Output format - 2P2' );
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
END_2P2
START_DUMP
END_DUMP
START_TEXT
END_TEXT
START_XML
END_XML
START_HTML
END_HTML