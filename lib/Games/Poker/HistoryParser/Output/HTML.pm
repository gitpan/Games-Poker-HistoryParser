package Games::Poker::HistoryParser::Output::HTML;

use warnings;
use strict;
use Carp;
use Exporter;
use Data::Dumper;
use Games::Poker::HistoryParser::Sites::Common;

our @ISA = qw(Exporter);
our $VERSION = '1.0';
our $error = "";
our @EXPORT;

@EXPORT = qw(
    get_output
);

sub get_output{
    my ( $data, $result_type, $showstacks ) = @_;

    my $output;
    
    $output .= $data->{'site'} . ' ' . $data->{'stakes'} . ' ' . $data->{'game_display'} . ' (' . $data->{'active_players'} . " handed)\n\n";
    
    my $rounds = rounds( $data->{'game'} );

    my $hero = _get_hero( $data->{'players'} );
    
    $output .= _get_stacks( $data->{'players' }, $data->{'symbol'} ) if $showstacks;    
    
    foreach my $round ( @$rounds ){
        
        $output .= _format_text($round . ":", 'bold' );
        
        if( lc $round eq 'preflop' ){
            $output .= " $hero.";
        }else{
            $output .= ' (' . $data->{'potsize'}{ lc $round } . ')';
            $output .= ' ' . _format_cards( $data->{'board'}{ lc $round} );
            $output .= ' ' . _format_text( '(' . _player_count( $data->{'action'}{ lc $round } ) . ' players)', 'blue' );
        }

        $output .= "\n";

        my @action;
        foreach ( split /\//, $data->{'action'}{lc $round } ){
            my ( $name, $player_action, $amount ) = split /\s/;
            push @action, $data->{'players'}{$name}{'position_name'} . ' ' . $player_action;
        }

        # Compress folds into the format "<number> folds"
        my ( $fold_start, $fold_end, $fold_count );
        for( my $i = 0; $i < $#action; $i++ ){
            
#           next unless $action[$i] =~ m/folds/;

            if( $action[$i] =~ m/folds/ ){
                if( ! defined $fold_count ){
                    $fold_start = $i;
                    $fold_end = $i;
                }else{
                    $fold_end = $i;
                }
                
                $fold_count++;

            }else{

                # Insert the number of folds at the first position
                # Check the count to get the right word.
                if( $fold_count ){
                    
                    $action[$fold_start] = $fold_count;
                    if( $fold_count == 1 ){
                        $action[$fold_start] .= ' fold';
                    }else{ 
                        $action[$fold_start] .= ' folds';
                    }
                            
                    $action[$fold_start] = _format_text( $action[$fold_start], 'italic' );
                    $action[$fold_start] = _format_text( $action[$fold_start], 'gray' );
                
                    # Remove all other fold actions and reset counters;
                    for( my $j = $fold_start+1; $j <= $fold_end; $j++ ){
                        $action[$j] = undef;
                    }
                }

                ( $fold_start, $fold_end, $fold_count ) = undef;

            }

        }

        my @compressed_actions;
        foreach( @action ){
            next unless defined $_;
            push @compressed_actions, $_ if m/\w/;
        }

        my $action_line = join ", ", @compressed_actions;
        $output .= $action_line . "\n\n";               

    }

    $output .= _format_text( 'Final Pot:', 'bold' ) . ' ' . $data->{'potsize'}{'showdown'} . "\n\n";
    
    $output .= "Results in white below:\n";
    
    my $results = _get_results( $data->{'players'}, $data->{'symbol'}, $data->{'sidepot_flag'} );
    $results = _format_text( $results, 'white' );
    $output .= $results . "\n";
    
    $output =~ s/\n/\&\#60;br\&\#62;\n/g;
    
    return $output;
}

sub _get_results{
    my ( $data, $currency_symbol, $sidepot_flag ) = @_;
    
    my $result;
    foreach my $player ( keys %{ $data } ){
        next unless exists $data->{$player}{'final_hand'};
        
        $result .= $data->{$player}{'position_name'} . ' has ' . $data->{$player}{'cards'} . ' (' . $data->{$player}{'final_hand'} . ")\n";
    }

    foreach my $player ( keys %{ $data } ){
        next unless $data->{$player}{'pots'};
        
        foreach( @{ $data->{$player}{'pots'} } ){
            $result .= 'Outcome: ' . $data->{$player}{'position_name'} . ' wins ' . $currency_symbol . $_->{'amount'};
            $result .= " from $_->{'pot'} pot" if $sidepot_flag;
            $result .= "\n";
        }
    }
     
    
    
    return $result;
    
}

sub _player_count{
    my ( $action ) = @_;
    
    my @actions = split /\//, $action;
    
    my %players;
    foreach( @actions ){
        my ( $player ) = split /\s+/;
        $players{ $player }++;
    }
    
    my @players = keys %players;
    return scalar @players;
        
}

sub _get_hero{
    my ( $data ) = @_;
    
    foreach my $player ( keys %{$data} ){
        next unless exists $data->{$player}{'is_hero'};
        
        return "Hero is " . $data->{$player}{'position_name'} . " with " . _format_cards( $data->{$player}{'hand'} );
    } 
    
    return "Hero is not playing this hand";  
}

sub _format_cards{
    my ( $hand ) = @_;

    $hand =~ s/^\s+//;
    $hand =~ s/\s+$//;

    my %suits = ( s => 's', c => 'c', h => 'h', d => 'd' );
        
    my ( @cards ) = split /\s+/, $hand;

    my @converted_hands;
    foreach my $card ( @cards ){
        my ( $rank, $suit ) = split //, $card;
        
        push @converted_hands, $rank . $suits{ $suit };
    }
    
    return join ", ", @converted_hands;
}

sub _get_stacks{
    my ( $players, $symbol ) = @_;

    my @seats;
    foreach my $player ( keys %{ $players } ){
        
        my $seat = $players->{$player}{'seat'};
        my $position = $players->{$player}{'position_name'};
        
        if( $players->{$player}{'is_hero'} && $players->{$player}{'is_hero'} == 1 ){
            $position .= ' (Hero)';    
        }            
        
        $seats[$players->{$player}{'seat'}] = $seat . '|' . $position . '|' . $symbol . $players->{$player}{'stack'};
    }

    my $stack_output = "Starting Stacks\n";
    for( my $i = 1; $i <= $#seats; $i++ ){
        next unless $seats[$i];
        my ( $seat, $position, $stack ) = split /\|/, $seats[$i];
        $stack_output .= "Seat $seat: $position ($stack)\n";
    }

    $stack_output .= "\n";
    
    return $stack_output;
}

sub _format_text{
    my ( $text, $format ) = @_;
    return '&#60;em&#62;' . $text . '&#60;/em&#62;'                       if $format eq 'italic';
    return '&#60;strong&#62;' . $text . '&#60;/strong&#62;'               if $format eq 'bold'; 
    return '&#60;font color="#666666"&#62;' . $text . '&#60;/font&#62;' if $format eq 'gray';
    return '&#60;font color="#0000FF"&#62;' . $text . '&#60;/font&#62;' if $format eq 'blue';
    return '&#60;font color="#FFFFFF"&#62;' . $text . '&#60;/font&#62;' if $format eq 'white';
    return $text;
}

1;

__END__

=head1 NAME

Output::HTML - Output module for HTML format

=head1 SYNOPSIS

 use Output::HTML;

=head1 FUNCTIONS

=head2 get_output( $parsed_hand_history );


=head1 DESCRIPTION

This module has a single function that returns the hand history in a format suitable for posting
to the internet.  

=head1 AUTHOR

Troy Denkinger (troy@pokergeek.com)

=head1 VERSION

Version 1.0

=head1 COPYRIGHT

Copyright (c) 2005 by Troy Denkinger, all rights reserved.  This is free software; you can 
redistribute it and/or modify it under the same terms as Perl itself.

=cut