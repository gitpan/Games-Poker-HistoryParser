package Elements::Form;

use warnings;
use strict;
use Carp;
use Exporter;

our @ISA = qw(Exporter);
our $VERSION = '1.0';
our $error = "";
our @EXPORT;

@EXPORT = qw(
    main_form
    start_form
    end_form
);

sub start_form{
    my ( $cgih ) = @_;
    
    if( $cgih->param('output') eq 'diagrammer' ){
        print $cgih->header('image/png');
	}else{
        print $cgih->header();
        print $cgih->start_html( -title=>"Reference implementation for Games::Poker::HistoryParser" );    
    }
}

sub main_form{
    my ( $cgih ) = @_;
    
    my $raw_history = '';
    $raw_history = $cgih->param( 'raw_history' ) if defined $cgih->param( 'raw_history' );

print<<FORM;

    <form method="post" action="convert.cgi">
    <table border="0">
        <tr>
            <td valign="top" align="center">
                <strong>Hand History</strong><br>
                <textarea name="raw_history" rows="20" cols="70">$raw_history</textarea>
            </td>
            <td valign="top">
                <strong>Output</strong><br>
                <input type="radio" name="output" value="2p2" checked>Two Plus Two Forums</a><br>
                <input type="radio" name="output" value="text">Plain Text</a><br>
                <input type="radio" name="output" value="xml">XML</a><br>
                <input type="radio" name="output" value="html">HTML</a><br>
                <input type="radio" name="output" value="dump">Data Structure Dump</a><br>
                
                <br>
                <br>
                Results
                <select name="results">
                <option value="none">No Results
                <option value="hidden">Hidden (in white)
                <option value="show">Show (in black)
                </select>
                <br>
                <br>
                Starting Stacks
                <select name="showstacks">
                <option value="1">Show
                <option value="0">Hide
                </select>                
                <br>
                <br>
                <div align="right">
                <a href="http://www.pokergeek.com/software/README" target="window">Project Overview</a><br>
                <a href="http://www.pokergeek.com/software" target="window">Get source code</a><br>
                <a href="http://www.pokergeek.com/software/status_grid.htm" target="window">Supported Hand Histories</a><br>
                </div>
                <br>
                <a href="mailto:perl\@pokergeek.com">Please Report Problems Here</a><br>
                If you report a problem,<br>please include the hand history<br>
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                <input type="submit" value="Convert">
            </td>
        </tr>
    </table>

    </form>

FORM

}

sub end_form{
    my ( $cgih ) = @_;
    print $cgih->end_html();    
}

1;

__END__

=head1 NAME

Elements::Form - Web interface used by reference CGI script

=head1 SYNOPSIS

 use Elements::Form;

 my $cgih = new CGI;

 start_form( $cgih );
 
 main_form( $cgih );
 
 end_form( $cgih ); 


=head1 DESCRIPTION

The functions in this module are used to display a HTML form to the user for use with the 
convert.cgi reference implementation.

=head1 AUTHOR

Troy Denkinger (troy@pokergeek.com)

=head1 VERSION

Version 1.0

=head1 COPYRIGHT

Copyright (c) 2005 by Troy Denkinger, all rights reserved.  This is free software; you can 
redistribute it and/or modify it under the same terms as Perl itself.

=cut
