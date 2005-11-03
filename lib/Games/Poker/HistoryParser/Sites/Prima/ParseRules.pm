package Games::Poker::HistoryParser::Sites::Prima::ParseRules;

use Carp;
use Exporter;
use Data::Dumper;

@ISA = qw(Exporter);
$VERSION = '1.0';
$error = "";

@EXPORT = qw(
    get_rules
);

sub get_rules{
    my ( $type ) = @_;
    
    my %rules = ( he     => { 
                                'limit_tournament'         => undef,
                                'nolimit_tournament'     => undef,
                                'limit_ring'            => '\*\*\s.+\[Hold\s\'em\]\s\((.*)Fixed\sLimit\s\-\sCash\sGame\)',
                                'potlimit_tournament'    => undef,
                                'nolimit_ring'            => undef,
                                'potlimit_ring'            => undef,
                                  'button'                  => '\-.*sitting in seat\s(\d+).*[Dealer]',
                                  'hand_id'                 => '\*\*\sGame\sID\s(\d+)',
                                'hero_hand'             => undef,
                                'get_winner'            => undef,
                                'get_posts'                => undef,
                                'get_stacks'            => undef,
                                'get_shown_cards'        => undef,
                                'get_rake'                => undef,
                                   'action'                => {
                                                                                  
                                                               'preflop'        => '\*{2}\sDealing\scard\sto(.*?)\*{2}',
                                                               'flop'            => '\*{2}\sDealing\sthe\sflop:\s(.*?)\*{2}',
                                                               'turn'            => '\*{2}\sDealing\sthe\sturn:\s(.*?)\*{2}',
                                                               'river'            => '\*{2}\sDealing\sthe\sriver:\s(.*?)\sEnd',
                                                              },
                               },
                    oh      => { },
                  );

    return $rules{ lc $type };                      
}
    
1;

__END__
=head1 NAME

Games::Poker::HistoryParser::Sites::Prima::ParseRules

=head1 SYNOPSIS

 use Games::Poker::HistoryParser::Sites::Prima::ParseRules;

=head2 get_rules();


=head1 DESCRIPTION

=head1 AUTHOR

Troy Denkinger (troy@pokergeek.com)

=head1 VERSION

Version 1.0

=head1 COPYRIGHT

Copyright (c) 2005 by Troy Denkinger, all rights reserved.  This is free software; you can 
redistribute it and/or modify it under the same terms as Perl itself.

=cut