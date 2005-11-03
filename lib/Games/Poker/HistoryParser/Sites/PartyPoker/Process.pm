package Games::Poker::HistoryParser::Sites::PartyPoker::Process;

use Carp;
use Exporter;
use Data::Dumper;

use Games::Poker::HistoryParser::Sites::PartyPoker::ParseRules;

@ISA = qw(Exporter);
$VERSION = '1.0';
$error = "";

@EXPORT = qw(
    process
);

sub process{
    my ( $history, $showstacks ) = @_;

    my $cap = 4; # Betting cap  
    my $site = 'PartyPoker';
    
    my ( $game, $game_display, $hilo_flag ) = _determine_game( $history );

    if( $game && ( $game eq 'HE' || $game eq 'OH' ) ){

        require Games::Poker::HistoryParser::Sites::PartyPoker::FlopGames;
        return Games::Poker::HistoryParser::Sites::PartyPoker::FlopGames::parse_hand( $history, 
                                                         $game, 
                                                         $game_display, 
                                                         $hilo_flag, 
                                                         $site, 
                                                         get_rules( $game ) 
                                                       );
        
    }elsif( $game ){
            die "$game currently unimplemented\n";
        
    }else{
        die "Hand history is incompatible\n";
    }

}

sub _determine_game{
    my ( $history ) = @_;
  
    return 'HE', 'Hold\'em', 0              if ( $history =~ m/Hold'em - /) || ($history =~ m/Hold'em[^\n]*Trny:\d+/ );
    return 'OH', 'Omaha High', 0            if ( $history =~ m/Omaha Hi - /i);
    return 'OH', 'Omaha/8', 1               if ( $history =~ m/Omaha Hi\/Lo/i);
    return '7S', 'Seven Card Stud High', 0  if ( $history =~ m/7 Card Stud - /i);
    return '7S', 'Seven Card Stud Hi/Lo', 1 if ( $history =~ m/7 Stud Hi\/Lo/i) ;

    return undef;
}

1;

__END__

=head1 NAME

Sites::PartyPoker::Process - Primary interface for Poker Stars hand histories.

=head1 SYNOPSIS

 use Sites::PokerStars;

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