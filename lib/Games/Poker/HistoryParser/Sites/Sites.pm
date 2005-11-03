package Games::Poker::HistoryParser::Sites::Sites;

use warnings;
use strict;
use Carp;
use Exporter;
use Data::Dumper;

our @ISA = qw(Exporter);
our $VERSION = '1.3';
our $error = "";
our @EXPORT;

@EXPORT = qw(
    process_hand
);

sub process_hand{
    my ( $history, $showstacks ) = @_;

    my %regex = ( 
                    'PokerStars'  => 'PokerStars Game',
                    'PartyPoker'  => '\*{5} Hand History for Game \d+ \*{5}',
                    'UltimateBet' => 'Powered by UltimateBet'
                );

    if( $history =~ m/$regex{'PartyPoker'}/i){  

        require Games::Poker::HistoryParser::Sites::PartyPoker::Process;
        return Games::Poker::HistoryParser::Sites::PartyPoker::Process::process( $history, $showstacks );
        
    }elsif( $history =~ m/$regex{'PokerStars'}/i){  

        require Games::Poker::HistoryParser::Sites::PokerStars::Process;    
        return Games::Poker::HistoryParser::Sites::PokerStars::Process::process( $history );
    
    }elsif( $history =~ m/$regex{'UltimateBet'}/i){  

        require Games::Poker::HistoryParser::Sites::UltimateBet::Process;    
        return Games::Poker::HistoryParser::Sites::UltimateBet::Process::process( $history );
    
    }elsif( $history =~ m/\*\*\sGame\sID\s\d+\sstarting/ && $history =~ m/End of game/ ){

        require Games::Poker::HistoryParser::Sites::Prima::Process;
        return Games::Poker::HistoryParser::Sites::Prima::Process::process( $history );
        
    }else{  
        
        return undef;
    
    }

}

1;

__END__

=head1 NAME

Sites::Sites - Primary interface for determining what site a hand history is from

=head1 SYNOPSIS

 use Sites::Sites;

=head2 my ( $parsed_hand_history ) = process_hand( $raw_hand_history );


=head1 DESCRIPTION

This module has a single function that is called using the raw hand history file as the sole
parameter.  The hand history is searched to determine site it came from.  The hand is then
parsed using the appropriate parser and the parsed hand data is returned to the calling
program.  The data put from this module is reading for input to the Output::Output.pm module.

=head1 AUTHOR

Troy Denkinger (troy@pokergeek.com)

=head1 VERSION

Version 1.0

=head1 COPYRIGHT

Copyright (c) 2005 by Troy Denkinger, all rights reserved.  This is free software; you can 
redistribute it and/or modify it under the same terms as Perl itself.

=cut