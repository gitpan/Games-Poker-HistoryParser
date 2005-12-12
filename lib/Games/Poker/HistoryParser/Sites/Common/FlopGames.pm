package Games::Poker::HistoryParser::Sites::Common::FlopGames;

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
	get_bets
	get_posts
	name_positions
);

sub get_bets{
    my ( $metadata, $regex ) = @_;

    my $pot = 0;
    
    # Look at the posts and add those to the pot
    foreach my $player ( keys %{ $metadata->{'players'} } ){
       next unless exists $metadata->{'players'}{$player}{'post_amount'};

       if( $metadata->{'players'}{$player}{'posted'} eq 'small blind' ){
           # look at preflop action, if the poster didn't raise/call, add the amount
           if( $metadata->{'action'}{'preflop'} !~ m/$player calls/i &&
               $metadata->{'action'}{'preflop'} !~ m/$player raises/i){
               $pot += $metadata->{'players'}{$player}{'post_amount'};
           } 
       }else{
           $pot += $metadata->{'players'}{$player}{'post_amount'};
       }
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

sub name_positions{
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

sub get_posts{
    my ( $history, $metadata, $regex ) = @_;
    
    my @lines = split /\n/, $history;

    foreach( @lines ){
        next unless m/$regex->{'get_posts'}/i;
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


1;

__END__

=head1 NAME

Sites::Common::FlopGames - functions common to all flop games

=head1 SYNOPSIS

 use Sites::Common::FlopGames;

=head1 FUNCTIONS 

=head2 get_bets( $metadata, $regex );
 
=head2 get_posts( $history, $metadata, $regex );

=head2 name_positions( $metadata );

=head1 DESCRIPTION

Regardless of online site, there are functions specific to all flop games, and those
are encompassed in this package.  These are functions that operate on the already parsed
hand histories, so the data given to each function is the same regardless of the format
of the original hand history.

=head1 AUTHOR

Troy Denkinger (troy@pokergeek.com)

=head1 VERSION

Version 1.0

=head1 COPYRIGHT

Copyright (c) 2005 by Troy Denkinger, all rights reserved.  This is free software; you can 
redistribute it and/or modify it under the same terms as Perl itself.

=cut