#!c:/perl/bin/perl.exe

use warnings;
use strict;
use Data::Dumper;
use Output::Output;
use Sites::Sites;
use CGI;
use Elements::Form;

my $cgih = new CGI;

start_form( $cgih );

main_form( $cgih );

if( defined $cgih->param( 'raw_history' ) ){
	my $game    = process_hand( $cgih->param( 'raw_history') );
#	my $invalid = validate( $game, $cgih->param( 'invalidate' ) );	
my $invalid;
	if( $invalid ){

		print "Game output did not validate.\n";
		print "Reason: $invalid\n";
	
	}else{

		my $output  = show( $game, $cgih->param( 'output' ), $cgih->param( 'results' ), $cgih->param( 'showstacks' ) );
		if( $output ){
			print "<hr>";
			print "Copy and paste the text below<br>";
			print "<hr>";
			print "<textarea rows=\"30\" cols=\"70\">";
			print $output;
			print "</textarea>";
		}else{
			print "error<br>";
		}
	}
}

end_form( $cgih );

__END__

=head1 NAME

convert.cgi - CGI script to interface to hand history parsing and display modules

=head1 DESCRIPTION

This is a CGI script providing a reference implementation to the hand history parsing
and output modules.  See conver.pl for an in-depth discussion of options passable
to these modules.

=head1 AUTHOR

Troy Denkinger (troy@pokergeek.com)

=head1 VERSION

Version 1.0

=head1 COPYRIGHT

Copyright (c) 2005 by Troy Denkinger, all rights reserved.  This is free software; you can 
redistribute it and/or modify it under the same terms as Perl itself.

=cut