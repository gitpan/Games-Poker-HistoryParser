package Games::Poker::HistoryParser::Output::Diagrammer;

use warnings;
use strict;
use Carp;
use Exporter;
use Data::Dumper;
use GD;
use Games::Poker::HistoryParser::Sites::Common;

our @ISA = qw(Exporter);
our $VERSION = '1.0';
our $error = "";
our @EXPORT;

@EXPORT = qw(
    get_output
);

sub get_output{
    my ( $data ) = @_;

	my %players;
	foreach my $name ( keys %{ $data->{'players'} } ){

		my $seat = $data->{'players'}{$name}{'seat'};
		$players{ $seat }{'name'}  = $name;
		$players{ $seat }{'stack'} = $data->{'players'}{$name}{'stack'};
		$players{ $seat }{'cards'} = $data->{'players'}{$name}{'cards'};
		$players{ $seat }{'post'}  = $data->{'players'}{$name}{'posted'};
	
	}

#		description	=> $args{'description'},
#		stakes		=> $args{'stakes'},
#		smallblind  => $args{'smallblind'},
#		bigblind	=> $args{'bigblind'},
#		ante		=> $args{'ante'},
#		copyright	=> 'Pokergeek.com',
#		button		=> $args{'button'},
#		logo		=> undef,
#		players		=> undef

	my $description = join ' ', 
	                       $data->{'site'}, 
                           $data->{'structure'}, 
                           $data->{'game_display'}, 
                           $data->{'type'}, 
                           '-' , $data->{'stakes'}, $data->{'stakes_desc'}, 
                           " ($data->{'active_players'} handed)";

	return _draw( players => \%players, description => $description );
}


sub _draw{
	my ( %args ) = @_;
	
	my $seats	= $args{'players'};

	my @positions = ( '100,200,167,193', '200,125,222,234', '325,105,250,260', '460,105,277,286', '600,125,306,318', '700,200,346,14', '600,275,41,54', '460,295,73,83', '325,295,100,110', '200,275,126,138' );
	my @arcs	  = ( '14,42', '54,73', '83,100','110,126','138,167', '193,222', '234,250', '260,277', '286,306', '318,346' );

	my $im = new GD::Image(800,400); 

	# allocate some colors
	my $white = $im->colorAllocate(255,255,255);
	my $red   = $im->colorAllocate(255,0,0);
	my $black = $im->colorAllocate(0,0,0);       

	# make the background transparent and interlaced
	$im->transparent( $white );
	$im->interlaced( 'true' );
	$im->setThickness( 2 );

	$im->rectangle( 0, 0, 800, 400, $black );

	foreach( @arcs ){
		my ( $start, $finish ) = split /,/;

		$im->arc( 400, 200, 600, 200, $start, $finish, $black );
	}

	my $count;
	foreach( @positions ){
		$count++;

    	my ( $x, $y, $start, $finish ) = split /,/;

		if( $count == $args{'button'} ){
	    	$im->filledArc( $x , $y, 50, 50, 0, 360, $black );		
			
	    	$seats->{$count}{'cards'} = _fix_cards( $seats->{$count}{'cards'} );
			$seats->{$count}{'name'}  = _fix_name(  $seats->{$count}{'name'}  );
			
			$im->string( gdGiantFont, $x - 21, $y - 7, $seats->{$count}{'name'} , $white );	    
			$im->string( gdGiantFont, $x - 18, $y + 50, $seats->{$count}{'stack'} , $black );		
			$im->string( gdGiantFont, $x - 18, $y + 30, $seats->{$count}{'cards'} , $black );		
			
		}else{
			if( $start && $finish && ! exists $seats->{ $count } ){
				$im->arc( 400, 200, 600, 200, $start, $finish, $black );		
			}else{
		    	$im->arc( $x , $y, 50, 50, 0, 360, $black );
		    	
		    	$seats->{$count}{'cards'} = _fix_cards( $seats->{$count}{'cards'} );
				$seats->{$count}{'name'}  = _fix_name(  $seats->{$count}{'name'}  );
						    	
	 			$im->fill( $x, $y, $white );	    
				$im->string( gdGiantFont, $x - 21, $y - 7, $seats->{$count}{'name'} , $black );
				$im->string( gdGiantFont, $x - 18, $y + 50, $seats->{$count}{'stack'} , $black );
				$im->string( gdGiantFont, $x - 18, $y + 30, $seats->{$count}{'cards'} , $black );
			}
		}

		next unless defined $seats->{$count}{'post'};

		if( $seats->{$count}{'post'} =~ m/^sb$/i ){
			$im->string( gdGiantFont, $x - 10, $y - 45, "SB" , $black );		
		}
		
		if( $seats->{$count}{'post'} =~ m/^bb$/i ){
			$im->string( gdGiantFont, $x - 10, $y - 45, "BB" , $black );		
		}	
		
		if( $seats->{$count}{'post'} =~ m/^sbbb$/i ){
			$im->string( gdGiantFont, $x - 10, $y - 45, "SB/BB" , $black );		
		}			
			
	}
	
	$im->copy( $args{'logo'} , 5 , 200 , 0, 0, 100, 75 ) if defined $args{'logo'};
	$im->string( gdGiantFont, 5, 5, $args{'description'}, $black );
	$im->string( gdGiantFont, 20, 25, "Stakes: " . $args{'stakes'}, $black ) if defined $args{'stakes'};
	$im->string( gdGiantFont, 20, 40, "Ante: " . $args{'ante'},     $black ) if defined $args{'ante'};
	
	$im->string( gdSmallFont, 5, 384, $args{'copyright'} , $black ) if defined $args{'copyright'};		
	return $im->png;
}

sub _fix_cards{
	my ( $cards ) = @_;
	
	$cards =~ s/\s//g;
	
	return $cards;
}

sub _fix_name{
	my ( $name ) = @_;
	
	$name = substr $name, 0, 5 if length $name > 5;

	while( length $name < 4 ){
		$name = ' ' . $name . ' ';
	}
	
	return $name;	
		
}

1;

__END__

=head1 NAME

Output::Diagrammer - Output module for HOH Diagrammer format

=head1 SYNOPSIS

 use Output::Diagrammer;

=head2 get_output

 my $output = get_output( $parsed_hand_history );

=head1 DESCRIPTION

This module has a single function that returns the hand history as a graphical representation in
the style found in the Harrington On Hold'em books.

=head1 AUTHOR

Troy Denkinger (troy@pokergeek.com)

=head1 VERSION

Version 1.0

=head1 COPYRIGHT

Copyright (c) 2005 by Troy Denkinger, all rights reserved.  This is free software; you can 
redistribute it and/or modify it under the same terms as Perl itself.

=cut