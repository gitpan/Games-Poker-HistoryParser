package Games::Poker::HistoryParser::Sites::FullTilt::ParseRules;

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
                                'limit_tournament'      => undef,
                                'nolimit_tournament'    => 'Tournament\s.+\sHold\'em\sNo\sLimit.+Level\s(.*)\s\((\d+)\/(\d+)\)',
                                'limit_ring'            => '\$(2)\/\$(4)\s\-\sLimit\sHold\'em\s\-',
                                'potlimit_tournament'   => undef,
                                'nolimit_ring'          => 'Hold\'em\sNo\sLimit\s\(\$(\d+\.\d\d)\/\$(\d+\.\d\d)\)',
                                'potlimit_ring'         => undef,
                                'button'                => 'Seat #(\d+) is the button.*?\n',
                                'hand_id'               => 'PokerStars Game #(\d+):',
                                'hero_hand'             => 'Dealt\sto\s(.*)\s\[(.*)\]',
                                'get_winner'            => '^(.*)\swins\sthe\spot\s\(\$(.*)\)',
                                'get_posts'             => '^(.*)\sposts\sthe\s(\w+ blind)\sof\s\$(.*)',
                                'get_stacks'            => '^Seat\s(\d+):\s(.*)\s\(\$(.*)\)',
                                'get_shown_cards'       => '^(.*)\s(shows|doesn*t show)\s+\[(.*)]\s\((.+)\)',
                                'get_rake'              => '^Total\spot.*\|\sRake\s\$+(.*)$',
                                'action'                => {
                                                               'preflop'  => '\*{3}\shole\scards\s\*{3}(.*?)\*{3}',
                                                               'flop'     => '\sflop\s\*{3}(.*?)\*{3}',
                                                               'turn'     => '\sturn\s\*{3}(.*?)\*{3}',
                                                               'river'    => '\sriver\s\*{3}(.*?)\*{3}',
                                                               'showdown' => '\sshow\sdown\s\*{3}(.*?)\*{3}',
                                                               'summary'  => '\ssummary\s\*{3}(.*)'
                                                              },
                               },
                  );

    return $rules{ lc $type };                      
}
    
1;

__END__

=head1 NAME

Games::Poker::HistoryParser::Sites::FullTilt::ParseRules

=head1 SYNOPSIS

 use Games::Poker::HistoryParser::Sites::FullTilt::ParseRules;

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