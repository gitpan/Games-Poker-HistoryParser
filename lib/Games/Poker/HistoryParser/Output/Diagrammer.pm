package Games::Poker::HistoryParser::Output::Diagrammer;

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
    my ( $data ) = @_;

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