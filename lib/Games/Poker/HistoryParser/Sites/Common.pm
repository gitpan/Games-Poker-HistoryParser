package Games::Poker::HistoryParser::Sites::Common;

use warnings;
use strict;
use Carp;
use Exporter;
use Data::Dumper;

our @ISA = qw(Exporter);
our $VERSION = '1.0';
our @EXPORT;

@EXPORT = qw(
    position_names
    rounds
);

sub position_names{
    my ( $game_type, $player_count ) = @_;

    if ( $game_type eq 'HE' || $game_type eq 'OH' ){
        
        my %position_names = ( 2 =>  'BB',
                               3 =>  'BB SB',
                               4 =>  'CO BB SB',
                               5 =>  'CO UTG BB SB',
                               6 =>  'CO LP UTG BB SB',
                               7 =>  'CO LP MP UTG BB SB',
                               8 =>  'CO LP MP UTG+1 UTG BB SB',
                               9 =>  'CO LP MP2 MP1 UTG+1 UTG BB SB',
                               10 => 'CO LP MP2 MP1 EP UTG+1 UTG BB SB',
                               11 => 'CO LP2 LP1 MP2 MP1 EP UTG+1 UTG BB SB'
                             );

        my @positions = split /\s+/, $position_names{ $player_count };
        return  \@positions;
            
    }else{
        return undef;   
    }
}


sub rounds{
    my ( $game_type ) = @_;

    if ( $game_type eq 'HE' || $game_type eq 'OH' ){
        my @rounds = qw( Preflop Flop Turn River );
        return \@rounds;
            
    }elsif( $game_type eq 'ST' ){
        my @rounds = qw( Third Fourth Fifth Sixth River );
        return \@rounds;
        
    }else{
        return undef;   
    }   
}

1;

__END__

=head1 NAME

Sites::Common - Data elements common to all poker sites

=head1 SYNOPSIS

 use Sites::Common;

=head1 FUNCTIONS 

=head2 position_names( $game_type, $player_count );
 
=head2 rounds( $game_type );

=head1 DESCRIPTION

This module has two functions that return general information about the poker games handled
by the parsers.  The name_positions function takes a game type and the number of players and 
returns the abbreviated names for each position.  The rounds function takes a game type and
returns the common names of each betting round for that game.  Both functions return array
references containing the requested data.

=head1 AUTHOR

Troy Denkinger (troy@pokergeek.com)

=head1 VERSION

Version 1.0

=head1 COPYRIGHT

Copyright (c) 2005 by Troy Denkinger, all rights reserved.  This is free software; you can 
redistribute it and/or modify it under the same terms as Perl itself.

=cut