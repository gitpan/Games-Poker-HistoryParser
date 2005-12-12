package Games::Poker::HistoryParser::Sites::Absolute::Process;

use Carp;
use Exporter;
use Data::Dumper;

use Games::Poker::HistoryParser::Sites::Absolute::ParseRules;

@ISA = qw(Exporter);
$VERSION = '1.0';
$error = "";

@EXPORT = qw(
    process
);

sub process{
    my ( $history, $showstacks ) = @_;

    my $cap = 4; # Betting cap  
    my $site = 'Absolute';
    
    my ( $game, $game_display, $hilo_flag ) = _determine_game( $history );

    if( $game && ( $game eq 'HE' || $game eq 'OH' ) ){

        require Games::Poker::HistoryParser::Sites::Absolute::FlopGames;
        return Games::Poker::HistoryParser::Sites::Absolute::FlopGames::parse_hand( $history, 
                                                         $game, 
                                                         $game_display, 
                                                         $hilo_flag, 
                                                         $site, 
                                                         get_rules( $game ) 
                                                       );
        
    }elsif( $game && $game eq 'ST' ){

    }else{
        die "Hand history is incompatible\n";
    }

}

sub _determine_game{
    my ( $history ) = @_;
  
    return 'HE', 'Hold\'em', 0              if ( $history =~ m/Holdem\s+/i );
#    return 'OH', 'Omaha/8', 1               if ( $history =~ m/Omaha\s+Hi\/Lo/i );
#    return 'OH', 'Omaha High', 0            if ( $history =~ m//i );
#    return '7S', 'Seven Card Stud High', 0  if ( $history =~ m//i );
#    return 'ST', 'Seven Card Stud Hi/Lo', 1 if ( $history =~ m/7\sCard\sStud\sHi\/Lo/i );

    return undef;
}

1;

__END__

=head1 NAME

Sites::Absolute::Process - Primary interface for Poker Stars hand histories.

=head1 SYNOPSIS

 use Sites::Absolute;

=head2 my ( $game, $full_game_name, $hilo_flag ) = process( $raw_hand_history );


=head1 DESCRIPTION

This module has a single function that is called using the raw hand history file as the sole
parameter.  The hand history is searched to determine the game name and whether the game
is a high/low split game.

=head1 AUTHOR

Troy Denkinger (troy@pokergeek.com)

=head1 VERSION

Version 1.0

=head1 COPYRIGHT

Copyright (c) 2005 by Troy Denkinger, all rights reserved.  This is free software; you can 
redistribute it and/or modify it under the same terms as Perl itself.

=cut