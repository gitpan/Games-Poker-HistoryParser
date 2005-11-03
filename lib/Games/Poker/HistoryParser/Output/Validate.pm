package Games::Poker::HistoryParser::Output::Validate;

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
    validate
);

sub validate{
    my ( $data, $force_invalidate ) = @_;
    
    return 'Forced invalidation requested' if $force_invalidate;
    return 'Game history contains no data' unless $data;
    
    my %validation_fields = (
                              players          => { score => 1, seen => 0 },
                              game_display      => { score => 1, seen => 0 },
                              hand_id         => { score => 1, seen => 0 },
                              bb_size         => { score => 1, seen => 0 },
                              potsize         => { score => 1, seen => 0 },
                              stakes         => { score => 1, seen => 0 },
                              symbol         => { score => 1, seen => 0 },
                              active_players => { score => 1, seen => 0 },
                              board             => { score => 1, seen => 0 },
                              site             => { score => 1, seen => 0 },
                              game             => { score => 1, seen => 0 },
                              structure         => { score => 1, seen => 0 },
                              action         => { score => 1, seen => 0 },
                              type             => { score => 1, seen => 0 },
                              button         => { score => 1, seen => 0 },
                              hilo_flag         => { score => 1, seen => 0 },
                            );

    my $top_score = 0;
    foreach my $validation_area ( keys %validation_fields ){
        $top_score += $validation_fields{ $validation_area }{ 'score' };
    }
    
    my $score = 0;
    foreach my $existing_area ( keys %{ $data } ){
        if( exists $validation_fields{ $existing_area } ){
            $score += $validation_fields{ $existing_area }{ 'score' };
            $validation_fields{ $existing_area }{ 'seen' }++;
        }
    }

    return 0 if $score == $top_score;
    
    my @missing_list;
    foreach my $validation_area ( keys %validation_fields ){
        push @missing_list, $validation_area if $validation_fields{ $validation_area }{ 'seen' } == 0;
    }
    
    my $error_message = 'Data elements in game history are missing or incorrect: ';
    $error_message .= join ', ', @missing_list;
    
    return $error_message;

}

1;

__END__

=head1 NAME

Output::Validate - Checks the data structures returned from Sites::* for validity

=head1 SYNOPSIS

 use Output::Validate;
 
=head1 FUNCTIONS 

=head2 validate( $output_from_sites );


=head1 DESCRIPTION

This modules purpose is to make sure the data structure returned from Sites::* is fit to be passed
to the Output::* module specified by the user.  Currently, this module just counts data elements
and compares them to the expected count.

=head1 AUTHOR

Troy Denkinger (troy@pokergeek.com)

=head1 VERSION

Version 1.0

=head1 COPYRIGHT

Copyright (c) 2005 by Troy Denkinger, all rights reserved.  This is free software; you can 
redistribute it and/or modify it under the same terms as Perl itself.

=cut