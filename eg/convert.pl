#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;
use Games::Poker::HistoryParser::Output::Output;
use Games::Poker::HistoryParser::Sites::Sites;
use Games::Poker::HistoryParser::Output::Validate;

our( $opt_help, $opt_verbose, $opt_file, $opt_output, $opt_result, $opt_invalidate, $opt_showstacks );

GetOptions( "help"          => \$opt_help,
            "verbose|v+"    => \$opt_verbose,
            "history|h=s"   => \$opt_file,
            "output|o=s"    => \$opt_output,
            "result|r=s"    => \$opt_result,
            "invalidate"    => \$opt_invalidate,
            "showstacks|s"  => \$opt_showstacks,
           ); 

pod2usage( -verbose => 2 ) unless $opt_file;
pod2usage( -verbose => 2 ) if $opt_help;

$opt_result = 'none' unless $opt_result;

open FH, $opt_file or die "Unable to open $opt_file: $!\n";
my $history;
{
    local $/;
    $history = <FH>;
}
close FH;

my $game    = process_hand( $history );
my $output  = show( $game, $opt_output, $opt_result, $opt_showstacks );
print $output, "\n";

__END__

=head1 NAME

convert.pl - script to interface to hand history parsing and display modules

=head1 SYNOPSIS

 convert.pl --history <path> [--output <type>] [--testfile <path>] [--results <hidden|show>] [--showstacks] [--help] [--verbose]

=over 4

=item --history, -h <path>

Hand history file to be parsed.  This file should contain a single hand.  Required.

=item --output, -o <path>

Output type requested.  These modules are flexible enough to allow output to many different
formats.  For instance, an output format for the Two Plus Two message boards is included; this
output module formats the hand to take into account particular features of that mesage board.
Other output formats may be provided and those are documented in the Output::Output.pm module.
If this argument is not present, a data dump of the hand will be returned.  Optional.

=item --testfile, -t <path>

A sample file to compare to the returned data from an output module.  This file functions as a
control when building new output modules.  It is assumed that this test file will be what you
are hoping to get from the output module.  When this option is used, the output from the
specified output module will be compared to this file.  If the data are identical a success 
message will be printed.  If they are not identical, a failure message will be printed.  
Optional.

=item --results, -r <hidden|show>

If this parameter is not present, no results will be shown.  If this parameter is present with a value of "hidden"
the results will be included in the results but the output color will be HTML white.  If this parameter
is present with a value of "show" then results will be included in HTML black.

=item --showstacks, -s

Include starting tacks in the output.

=item --help

This message.

=item --verbose, -v

Not implemented.

=back

=head1 DESCRIPTION

This script is a simple reference implementation of how to interface to the hand parsing and 
hand display modules.  This script can be used as-is or as the starting point for a new 
implementation such as a CGI script, etc.

=head1 AUTHOR

Troy Denkinger (troy@pokergeek.com)

=head1 VERSION

Version 1.0

=head1 COPYRIGHT

Copyright (c) 2005 by Troy Denkinger, all rights reserved.  This is free software; you can 
redistribute it and/or modify it under the same terms as Perl itself.

=cut