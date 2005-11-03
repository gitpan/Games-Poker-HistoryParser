package Games::Poker::HistoryParser::Output::Dump;

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
    get_output
);

sub get_output{
    my ( $data ) = @_;
    return Dumper $data;
}

1;

__END__

=head1 NAME

Output::Dump - Returns raw Data::Dumper output

=head1 SYNOPSIS

 use Output::Dump;

 my $output = get_output( $parsed_hand_history );

=head1 FUNCTIONS

=head2 get_output( [hand history data structure] );

    blah

=head1 DESCRIPTION

Very basic module that returns the parsed_hand_history data structure in it's most raw format.

=head1 AUTHOR

Troy Denkinger (troy@pokergeek.com)

=head1 VERSION

Version 1.0

=head1 COPYRIGHT

Copyright (c) 2005 by Troy Denkinger, all rights reserved.  This is free software; you can 
redistribute it and/or modify it under the same terms as Perl itself.

=cut