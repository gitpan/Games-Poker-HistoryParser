package Games::Poker::HistoryParser::Sites::PokerStars::FlopGames;

use warnings;
use strict;
use Carp;
use Exporter;
use Data::Dumper;

use Games::Poker::HistoryParser::Sites::Common::FlopGames;

our @ISA = qw(Exporter);
our $VERSION = '1.0';
our @EXPORT;

@EXPORT = qw(
    parse_hand
);

sub parse_hand{
    my ( $history, $game, $game_display, $hilo_flag, $site, $regex ) = @_;  

    my $game_meta = _get_metadata( $history, $regex );
    return undef unless $game_meta;

    $game_meta->{'game'}         = $game;
    $game_meta->{'game_display'} = $game_display;
    $game_meta->{'hilo_flag'}    = $hilo_flag;
    $game_meta->{'site'}         = $site;

    $game_meta = _get_action(       $history, $game_meta, $regex );
    $game_meta = _get_players(      $history, $game_meta, $regex );
    $game_meta = _get_winner(       $history, $game_meta, $regex );
    $game_meta = get_posts(        $history, $game_meta, $regex );
    $game_meta = get_bets(         $game_meta, $regex );
    $game_meta = _get_rake(            $history, $game_meta, $regex );

    return $game_meta;  
    
}

sub _get_metadata{
    my ( $history, $regex ) = @_;

    # These regexes determine what type of game is being played
    # Then it pulls out relevant pieces of metadata pertinent to that game type
    my %metadata;    
    if( $history =~ m/$regex->{'limit_ring'}/i ){

        my ( $bet_small, $bet_big ) = split /\//, $1;
        $metadata{ 'stakes' }    = $bet_small . '/' . $bet_big;
        $metadata{ 'stakes_desc'} = 'Stakes';
        $metadata{ 'structure' } = "Limit";
        $metadata{ 'type' }      = "Ring";

        $bet_small =~ s/^\$//;
        $bet_big   =~ s/^\$//;

        $metadata{ 'bet_small'}  = $bet_small;
        $metadata{ 'bet_big' }   = $bet_big;
        $metadata{ 'bb_size' }   = $metadata{ 'bet_small' };  

    }elsif ( $history =~ m/$regex->{'nolimit_ring'}/i ){

        $metadata{ 'stakes' }    = $1 . '/' . $2;
        $metadata{ 'stakes_desc'} = 'Blinds';        
        $metadata{ 'structure' } = "NL";
        $metadata{ 'type' }      = "Ring";
        $metadata{ 'bb_size' }   = $2
        
    }elsif( $history =~ m/$regex->{'nolimit_tournament'}/i ){

        $metadata{ 'stakes' }    = $2 . '/' . $3;
        $metadata{ 'stakes_desc'} = 'Blinds';        
        $metadata{ 'structure' } = "NL";
        $metadata{ 'type' }      = "Tournament";
        $metadata{ 'level' }     = $1;
        $metadata{ 'bb_size' }      = $3;
        
    }elsif( $history =~ m/$regex->{'limit_tournament'}/i ){

        $metadata{ 'stakes' }    = join '/', $2, $3;
        $metadata{ 'stakes_desc'} = 'Stakes';
        $metadata{ 'structure' } = "Limit";
        $metadata{ 'type' }      = "Tournament";

        $metadata{ 'bet_small'} = $2;
        $metadata{ 'bet_big' }  = $3;
        $metadata{ 'bb_size' } = $metadata{ 'bet_small' };  
       
    }elsif ( $history =~ m/$regex->{'potlimit_tournament'}/i ){ 

    }elsif ($history =~ m/$regex->{'potlimit_ring'}/i ){

    }else{
        # noop - just fall through
    }
    
    $metadata{ 'symbol' } = '$';
    $metadata{ 'symbol' } = 'T' if $metadata{'type'} eq 'Tournament';
    
    foreach my $regex_type ( 'button', 'hand_id' ){
        $history =~ m/$regex->{$regex_type}/i;
        $metadata{$regex_type} = $1;
    }
    
    return \%metadata;
    
}

sub _get_hero{
    my ( $history, $game_type, $regex ) = @_;
    
    $history =~ m/$regex->{'hero_hand'}/i;

    if( $1 ){
        return $1, $2;        
    }
    
    return undef, undef;
}



sub _get_winner{
    my ( $history, $metadata, $regex ) = @_;

    my @lines = split /\n/, $history;
    
    foreach( @lines ){
        next unless m/collected/;

        if( m/$regex->{'get_winner'}/ ){

            my $pot_type = 'main';
            if( $3 eq 'side' ){
                $pot_type = 'side';
                $metadata->{'sidepot_flag'} = 1;
            }
            
            push @{ $metadata->{'players'}{ $1 }{'pots'} }, { amount => $2, pot => $pot_type };
        }
    }

    return $metadata;   
}

sub _get_players{
    my ( $history, $metadata, $regex ) = @_;

    my @lines = split /\n/, $history;

    foreach( @lines ){
        next unless m/$regex->{'get_stacks'}/;

        my $seat        = $1;
        my $player_name = $2;
        my $stack       = $3;

        # Player name cleanup;
        $player_name =~ s/\s+$//;
        $player_name =~ s/\s+/%20/g;

        next unless $metadata->{'action'}{'preflop'} =~ m/$player_name/; # If the player doesn't act preflop, he's not a player

        $metadata->{'players'}{ $player_name }{'seat'} = $seat;
        $metadata->{'players'}{ $player_name }{'stack'} = $stack;
        $metadata->{'players'}{ $player_name }{'position_name'} = 'Button' if $seat == $metadata->{'button'};
    }

    foreach( @lines ){
        next unless m/$regex->{'get_shown_cards'}/;

        $metadata->{'players'}{ $1 }{'cards'} = $3;
        $metadata->{'players'}{ $1 }{'final_hand'} = $4;
    }

    my ( $hero_name, $hero_hand ) = _get_hero( $history, $metadata->{'game'}, $regex );
    
    if( $hero_name ){
        $metadata->{'players'}{ $hero_name }{'hand'}    = $hero_hand;
        $metadata->{'players'}{ $hero_name }{'is_hero'} = 1;
    }        

    $metadata = name_positions( $metadata );

    return $metadata;
}


sub _get_action{
    my ( $history, $metadata, $regex ) = @_;

    my ( $starting, $preflop, $flop, $turn, $river, $showdown, $summary );

    # We pull the history apart here
    ( $preflop )  = $history =~ m/$regex->{'action'}{'preflop'}/si;
    ( $flop )     = $history =~ m/$regex->{'action'}{'flop'}/si;
    ( $turn )     = $history =~ m/$regex->{'action'}{'turn'}/si;
    ( $river )    = $history =~ m/$regex->{'action'}{'river'}/si;
    ( $showdown ) = $history =~ m/$regex->{'action'}{'showdown'}/si;
    ( $summary )  = $history =~ m/$regex->{'action'}{'summary'}/si;

    $metadata->{'action'}{'preflop'} = $preflop if $preflop;

    if( $flop ){
        $flop =~ s/\[(\w{2}\s+\w{2}\s+\w{2})\]//;
          $metadata->{'board'}{'flop'}  = $1;
           $metadata->{'board'}{'flop'}  =~ s/\s/,/g;
        $metadata->{'action'}{'flop'} = $flop;;
       }
       
       if( $turn ){
        $turn =~ s/\[(\w{2})\]//;
           $metadata->{'board'}{'turn'}  = $1;
        $metadata->{'action'}{'turn'} = $turn;
    }
    
    if( $river ){
        $river =~ s/\[(\w{2})\]//;
           $metadata->{'board'}{'river'}  = $1;
        $metadata->{'action'}{'river'} = $river;
       }

    # A little more data cleanup across all strees;
    foreach my $street ( keys %{ $metadata->{'action'} } ){
         $metadata->{'action'}{ $street } =~ s/\sDealt to .+\]//;  # Dealt to data
         $metadata->{'action'}{ $street } =~ s|^\s+||;             # Leading spaces
         $metadata->{'action'}{ $street } =~ s|/+$||;              # Trailing slashes
         $metadata->{'action'}{ $street } =~ s|^/+||;              # Leading slashes
         $metadata->{'action'}{ $street } =~ s|^\s*\[.*\]\s*||;    # Cards
         $metadata->{'action'}{ $street } =~ s|\s*\n\s*|/|g;       # Cards
         
         
         my ( @action ) = split /\//, $metadata->{'action'}{ $street };

         for( my $i = 0; $i <= $#action; $i++ ){
             
              if( $action[$i] =~ m/\scollected(.*)from\spot|show\shand/i ){
                  $action[$i] = '';
                  next;
              }
              
              if( $action[$i] =~ m/\ssaid,\s/i || $action[$i] =~ m/\sleaves\sthe\stable/i ){
                  $action[$i] = '';
                  next;
              }

             #Encode spaces in player handles
             my ( $name, $action ) = split /:\s+/, $action[$i];
              $name =~ s/\s+/%20/g;
              $action[$i] = join ' ', $name, $action;

              #Change raise notation to standard    
              if( $action[$i] =~ m/raises/ ){
                 $action[$i] =~ s/raises\s.*\sto/raises/;
              }

              #Change all-in notation to standard    
              if( $action[$i] =~ m/all-in/i ){
                 my ( $player, $action, $amount ) = split /\s/, $action[$i];
                  $action[$i] = $player . ' all-in ' . $amount;
             }
           }

            $metadata->{'action'}{ $street } = join '/', @action;

   }

   return $metadata;
}

sub _get_rake{
    my ( $history, $metadata, $regex ) = @_;
    
    my @lines = split /\n/, $history;

    foreach( @lines ){
        next unless m/$regex->{'get_rake'}/i;
        $metadata->{'rake'} = $1;
        $metadata->{'rake'} =~ s/\s//g;
    }

    return $metadata;   
}


1;

__END__

=head1 NAME

Sites::PokerStars::FlopGames - Parsing of flop games such as Hold'em and Omaha

=head1 SYNOPSIS

 use Sites::PokerStars::FlopGames;

=head2 my ( $parsed_hand ) = parse_hand( $history, $game, $game_display, $hilo_flag, $site, $parsing_regexes );


=head1 DESCRIPTION

This modules uses the regexes defined for a particular game type to retrieve information from the hand history and 
then return a data structure containing that information.  This data structure is then suitable for processing
into varous output formats.

=head1 AUTHOR

Troy Denkinger (troy@pokergeek.com)

=head1 VERSION

Version 1.0

=head1 COPYRIGHT

Copyright (c) 2005 by Troy Denkinger, all rights reserved.  This is free software; you can 
redistribute it and/or modify it under the same terms as Perl itself.

=cut