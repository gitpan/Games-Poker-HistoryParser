package Games::Poker::HistoryParser::Output::Output;

use warnings;
use strict;
use Carp;
use Exporter;
use Data::Dumper;

our @ISA = qw(Exporter);
our $VERSION = '1.0';
our $error = "";
our @EXPORT;

@EXPORT = qw(
    show
);

sub show{
    my ( $data, $output_target, $result, $showstacks ) = @_;

    my $output;

    if( lc $output_target eq '2p2' ){

        require Games::Poker::HistoryParser::Output::2P2;
        $output = Games::Poker::HistoryParser::Output::2P2::get_output( $data, $result, $showstacks );

    }elsif( ! $output_target || lc $output_target eq 'dump' ){

        require Games::Poker::HistoryParser::Output::Dump;
        $output = Games::Poker::HistoryParser::Output::Dump::get_output( $data );

    }elsif( lc $output_target eq 'html' ){

        require Games::Poker::HistoryParser::Output::HTML;
        $output = Games::Poker::HistoryParser::Output::HTML::get_output( $data, $result, $showstacks );
        
    }elsif( lc $output_target eq 'text' ){

        require Games::Poker::HistoryParser::Output::Text;
        $output = Games::Poker::HistoryParser::Output::Text::get_output( $data, $result, $showstacks );
    
    }elsif( lc $output_target eq 'diagrammer' ){

        require Games::Poker::HistoryParser::Output::Diagrammer;
        $output = Games::Poker::HistoryParser::Output::Diagrammer::get_output( $data, $result, $showstacks );
    
    }elsif( lc $output_target eq 'xml' ){

        require Games::Poker::HistoryParser::Output::XML;
        $output = Games::Poker::HistoryParser::Output::XML::get_output( $data, $result, $showstacks );
    
    }else{

        return "The format \"$output_target\" is not currently supported";

    }

    $output =~ s/\s+$//;
    $output =~ s/^\s+//;
	
	return $output;

}

1;

__END__

=head1 NAME

Output::Output - Primary interface to all output modules.

=head1 SYNOPSIS

 use Output::Output;

=head1 FUNCTIONS

=head2 show( $parsed_hand_history, $output_module );


=head1 DESCRIPTION

This module has a single function that decides which output module to use based on the value
of the second parameter.  Once the proper output module is determined, the parsed hand history
data structure is passed to it.  The show() function returns the output to the caller.  An
unknown output module results in an undefined return value.

=head1 AUTHOR

Troy Denkinger (troy@pokergeek.com)

=head1 VERSION

Version 1.0

=head1 COPYRIGHT

Copyright (c) 2005 by Troy Denkinger, all rights reserved.  This is free software; you can 
redistribute it and/or modify it under the same terms as Perl itself.

=cut