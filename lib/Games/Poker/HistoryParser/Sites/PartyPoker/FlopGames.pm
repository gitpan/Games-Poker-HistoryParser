package Games::Poker::HistoryParser::Sites::PartyPoker::FlopGames;

use warnings;
use strict;
use Carp;
use Exporter;
use Data::Dumper;

use Games::Poker::HistoryParser::Sites::Common;

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
    $game_meta = _get_posts(        $history, $game_meta, $regex );
    $game_meta = _get_bets(         $game_meta, $regex );
    $game_meta = _get_rake(            $history, $game_meta, $regex );

    return $game_meta;  
    
}

sub _get_metadata{
    my ( $history, $regex ) = @_;

    # These regexes determine what type of game is being played
    # Then it pulls out relevant pieces of metadata pertinent to that game type
    my %metadata;
    if( $history =~ m/$regex->{'limit_tournament'}/i ){
        $metadata{ 'stakes' }    = undef
        $metadata{ 'stakes_desc'} = 'Stakes';        
        $metadata{ 'structure' } = "Limit";
        $metadata{ 'type' }      = "Tourney";

        $history =~ m/$regex->{'stakes'}/i;
        $metadata{ 'bet_small'} = $1;
        $metadata{ 'bet_big' }  = $2;
        $metadata{ 'bb_size' } = $metadata{ 'bet_small' };  

    }elsif( $history =~ m/$regex->{'nolimit_tournament'}/i ){
        $metadata{ 'stakes' }    = undef;
        $metadata{ 'stakes_desc'} = 'Blinds';        
        $metadata{ 'structure' } = "NL";
        $metadata{ 'type' }      = "Tourney";
        
        $history =~ m/$regex->{'level'}/i;
        $metadata{ 'bet_small'} = $1;
        $metadata{ 'bet_big' }  = $2;
        $metadata{ 'bb_size' } = $metadata{ 'bet_small' };  
        
    }elsif ( $history =~ m/$regex->{'potlimit_tournament'}/i ){ 
        $metadata{ 'stakes' }    = undef;
        $metadata{ 'stakes_desc'} = 'Blinds';        
        $metadata{ 'structure' } = "PL";
        $metadata{ 'type' }      = "Tourney";
        
        $history =~ m/$regex->{'level'}/i;
        $metadata{ 'bet_small'} = $1;
        $metadata{ 'bet_big' }  = $2;
        $metadata{ 'bb_size' } = $metadata{ 'bet_small' };  

    }elsif ( $history =~ m/$regex->{'limit_ring'}/i ){
        my ( $bet_small, $bet_big ) = split /\//, $1;
        $metadata{ 'stakes' }    = $bet_small . '/' . $bet_big;
        $metadata{ 'stakes_desc'} = 'Stakes';        
        $metadata{ 'structure' } = "Limit";
        $metadata{ 'type' }      = "Ring";

        $bet_small =~ s/^\$//;
        $bet_big   =~ s/^\$//;

        $metadata{ 'bet_small'} = $bet_small;
        $metadata{ 'bet_big' }  = $bet_big;
        $metadata{ 'bb_size' } = $metadata{ 'bet_small' };  

    }elsif ( $history =~ m/$regex->{'nolimit_ring'}/i ){
        $metadata{ 'stakes' }    = undef;
        $metadata{ 'stakes_desc'} = 'Blinds';        
        $metadata{ 'structure' } = "NL";
        $metadata{ 'type' }      = "Ring";

        if ( $history =~ m/$regex->{'bb_size'}/i ){
            $metadata{ 'bet_small'} = $1;
        }   

        $metadata{ 'bet_big'}  = 1;
        $metadata{ 'bb_size' } = $metadata{ 'bet_small' };  

        
    }elsif ($history =~ m/$regex->{'potlimit_ring'}/i ){
        $metadata{ 'stakes' }    = undef;
        $metadata{ 'stakes_desc'} = 'Blinds';        
        $metadata{ 'structure' } = "PL";
        $metadata{ 'type' }      = "Ring";

        if ( $history =~ m/$regex->{'bb_size'}/i ) {
            $metadata{ 'bet_small'} = $1;
        }   

        $metadata{ 'bet_big'}  = 1;
        $metadata{ 'bb_size' } = $metadata{ 'bet_small' };  
    
    }else{
        return undef;   
    }
    
    $metadata{'type'} eq 'Tourney' ? $metadata{ 'symbol' } = 'T' : $metadata{ 'symbol' } = '$';

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
        my $name = $1;
        my $hand = $2 . $3 . ' ' . $4 .$5;
    
        return $name, $hand;        
    }
    
    return undef, undef;
}


sub _get_winner{
    my ( $history, $metadata, $regex ) = @_;

    my @lines = split /\n/, $history;
    
    foreach( @lines ){
        next unless m/$regex->{'check_winner'}/;

        if( m/$regex->{'get_winner'}/ ){
            push @{ $metadata->{'players'}{ $1 }{'pots'} }, { amount => $2, pot => $4 };
            $metadata->{'sidepot_flag'} = 1 unless $4 eq 'main';  #if a sidepot has been awarded, flag it
        }elsif( m/$regex->{'get_winner_alt'}/ ){
            push @{ $metadata->{'players'}{ $1 }{'pots'} }, { pot => 'main', amount => $2 };        
        }
    }

    return $metadata;   
}

sub _get_posts{
    my ( $history, $metadata, $regex ) = @_;
    
    my @lines = split /\n/, $history;

    foreach( @lines ){
        next unless m/$regex->{'get_posts'}/;
        $metadata->{'players'}{ $1 }{'posted'} = $2;
        $metadata->{'players'}{ $1 }{'post_amount'} = $3;
        
        if( $metadata->{'players'}{ $1 }{'position_name'} eq 'BB' || $metadata->{'players'}{ $1 }{'position_name'} eq 'SB' ){
            $metadata->{'players'}{ $1 }{'position_name'} = ucfirst( $2 );
        }else{
               $metadata->{'players'}{ $1 }{'position_name'} .= ' (poster)';
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
        next unless $metadata->{'action'}{'preflop'} =~ m/$player_name/; # If the player doesn't act preflop, he's not a player
        
        $metadata->{'players'}{ $player_name }{'seat'} = $seat;
        $metadata->{'players'}{ $player_name }{'stack'} = $stack;
        $metadata->{'players'}{ $player_name }{'position_name'} = 'Button' if $seat == $metadata->{'button'};
    }

    foreach( @lines ){
        next unless m/$regex->{'get_shown_cards'}/;
        $metadata->{'players'}{ $1 }{'cards'} = $3 . $4 . ' ' . $5 . $6;
        $metadata->{'players'}{ $1 }{'final_hand'} = $7;
    }

    my ( $hero_name, $hero_hand ) = _get_hero( $history, $metadata->{'game'}, $regex );
    
    if( $hero_name ){
        $metadata->{'players'}{ $hero_name }{'hand'}    = $hero_hand;
        $metadata->{'players'}{ $hero_name }{'is_hero'} = 1;
    }        

    $metadata = _name_positions( $metadata );

    return $metadata;
}


sub _name_positions{
    my ( $metadata ) = @_;
    
    # We need a nice ordered list of all the players by seat number
    my @all_players;
    $metadata->{'active_players'} = 0;
    foreach my $player ( keys %{ $metadata->{'players'} } ){
        push @all_players, $metadata->{'players'}{$player}{'seat'};
        $metadata->{'active_players'}++;
    }
    @all_players = sort { $a <=> $b } @all_players;

    my ( $position_names ) = position_names( $metadata->{'game'}, $metadata->{'active_players'} );

    my %position_names;
    # Find the button and name the seats after the button
    foreach my $player ( @all_players ){

        if( $player == $metadata->{'button'} ){
            $position_names{ $player } = 'Button';
        }

        if( $player > $metadata->{'button'} ){      
            my $pos_name = pop @{ $position_names };
            $position_names{ $player } = $pos_name;         
        }
    }

    # The seats before the button are named in order until we run out of 
    # seat
    foreach my $player ( @all_players ){
        if( $player < $metadata->{'button'} ){
            my $pos_name = pop @{ $position_names };
            $position_names{ $player } = $pos_name;         
        }
    }

    foreach my $player ( keys %{ $metadata->{'players'} } ){
        $metadata->{'players'}{$player}{'position_name'} = $position_names{ $metadata->{'players'}{$player}{'seat'} };
    }
    
    return $metadata;   
}

sub _get_bets{
    my ( $metadata, $regex ) = @_;
    
    my $pot = 0;
    
    # Look at the posts and add those to the pot
    foreach my $player ( keys %{ $metadata->{'players'} } ){
        next unless exists $metadata->{'players'}{$player}{'post_amount'};
        $pot += $metadata->{'players'}{$player}{'post_amount'};
    }

    my %bets;
    my $rounds = rounds( $metadata->{'game'} );
    
    # Get the action to determine how much went in the pot and add it to the pot
    foreach my $street ( @$rounds ){
        next unless exists $metadata->{'action'}{ lc $street };
        
        my @actions = split /\//, $metadata->{'action'}{ lc $street };
    
        foreach( @actions ){
            next unless m/(bets|calls|raises)/;
            m/(bets|calls|raises)\s+\$*(.*)/i;
            my $amount = $2;
            $amount =~ s/\sall\-in//i;
            $pot += $amount if $amount;
        }

        $bets{ lc $street } = $pot;
    }
    
    # Take how much money is in on the prior round and make that the pot size at the
    # start of the round
;   
    # If this is a limit game, display as BB/SB otherwise use dollar amounts with the proper
    # currency symbol
    if( $metadata->{'structure'} eq 'Limit' ){
    
        $metadata->{'potsize'}{'flop'}      = $bets{'preflop'}  / $metadata->{'bet_small'} if exists $bets{'preflop'};
        $metadata->{'potsize'}{'turn'}      = $bets{'flop'}     / $metadata->{'bet_big'}   if exists $bets{'flop'};
        $metadata->{'potsize'}{'river'}     = $bets{'turn'}     / $metadata->{'bet_big'}   if exists $bets{'turn'};
        $metadata->{'potsize'}{'showdown'}  = $bets{'river'}    / $metadata->{'bet_big'}   if exists $bets{'river'};
    
        # Truncate to avoid very long decimal places
        foreach my $round ( keys %{ $metadata->{'potsize'} } ){
            $metadata->{'potsize'}{$round} = sprintf("%.2f", $metadata->{'potsize'}{$round} );
        }

        $metadata->{'potsize'}{'flop'}      .= ' SB';
        $metadata->{'potsize'}{'turn'}      .= ' BB';
        $metadata->{'potsize'}{'river'}     .= ' BB';
        $metadata->{'potsize'}{'showdown'}  .= ' BB';
    
    }else{
    
        $metadata->{'potsize'}{'flop'}      = $metadata->{'symbol'} . $bets{'preflop'}        if exists $bets{'preflop'};        
        $metadata->{'potsize'}{'turn'}      = $metadata->{'symbol'} . $bets{'flop'}         if exists $bets{'flop'};
        $metadata->{'potsize'}{'river'}     = $metadata->{'symbol'} . $bets{'turn'}         if exists $bets{'turn'};
        $metadata->{'potsize'}{'showdown'}  = $metadata->{'symbol'} . $bets{'river'}         if exists $bets{'river'};
    
    }
    
    return $metadata;   
}

sub _get_rake{
    my ( $history, $metadata, $regex ) = @_;

    $metadata->{'rake'} = 0;

    return $metadata;   
}

sub _get_action{
    my ( $history, $metadata, $regex ) = @_;

    $history =~ m/$regex->{'action'}/s;
    
    $metadata->{'action'}{'preflop'} = $1;
    $metadata->{'action'}{'flop'}    = $3;
    $metadata->{'action'}{'turn'}    = $5;
    $metadata->{'action'}{'river'}   = $7;

    $metadata->{'board'}{'flop'} = $2;
    $metadata->{'board'}{'turn'} = $4;
    $metadata->{'board'}{'river'} = $6;
    $metadata->{'board'}{'flop'} =~ s/\s//g;
    

    # A little more data cleanup across all strees;
    foreach my $street ( keys %{ $metadata->{'action'} } ){
        $metadata->{'action'}{ $street } =~ s/Dealt\sto\s.+//;
        $metadata->{'action'}{ $street } =~ s/.+\sshows\s.+//g;
        $metadata->{'action'}{ $street } =~ s/.+\sshow\s.+//g;
        $metadata->{'action'}{ $street } =~ s/.+\swins\s.+//g;
        $metadata->{'action'}{ $street } =~ s|\n|/|g;
        $metadata->{'action'}{ $street } =~ s|\.||g;
        $metadata->{'action'}{ $street } =~ s|/+$||;
        $metadata->{'action'}{ $street } =~ s|^/+||;
        $metadata->{'action'}{ $street } =~ s|\s+is\sall\-in\s+| all-in |ig;
        $metadata->{'action'}{ $street } =~ s|\[||g;
        $metadata->{'action'}{ $street } =~ s|\]||g;
        
         my ( @action ) = split /\//, $metadata->{'action'}{ $street };

         for( my $i = 0; $i <= $#action; $i++ ){
             
                if( $action[$i] =~ m/has\sleft\sthe\stable/i || $action[$i] =~ m/has\sjoined\sthe\stable/i ){
                    $action[$i] = '';
                    next;
                }

             #Encode spaces in player handles
             my ( $name, $action ) = split /\s+/, $action[$i], 2;
              $name =~ s/\s+/%20/g;
              $action[$i] = join ' ', $name, $action;
              
           }

            $metadata->{'action'}{ $street } = join '/', @action;        
        
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