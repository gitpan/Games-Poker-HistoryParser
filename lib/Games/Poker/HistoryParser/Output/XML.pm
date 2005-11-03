package Games::Poker::HistoryParser::Output::XML;

use warnings;
use strict;
use Carp;
use Exporter;
use Data::Dumper;
use XML::Simple qw( :strict );

our @ISA = qw(Exporter);
our $VERSION = '1.0';
our $error = "";
our @EXPORT;

@EXPORT = qw(
    get_output
);

sub get_output{
    my ( $data ) = @_;

    my $xs = new XML::Simple;
    my $xml = $xs->XMLout( $data, 
                           KeyAttr => undef, 
                           RootName => 'HandHistory', 
                           XMLDecl => 1
                         );
    
    return $xml
}


1;

__END__

=head1 NAME

Output::XML - Output module for an XML dump

=head1 SYNOPSIS

 use Output::XML

=head2 my $output = get_output( $parsed_hand_history );


=head1 DESCRIPTION

This module takes the input data format and outputs a raw XML dump.

=head1 AUTHOR

Troy Denkinger (troy@pokergeek.com)

=head1 VERSION

Version 1.0

=head1 COPYRIGHT

Copyright (c) 2005 by Troy Denkinger, all rights reserved.  This is free software; you can 
redistribute it and/or modify it under the same terms as Perl itself.

=cut