package Games::Poker::HistoryParser::Sites::Absolute::ParseRules;

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
                                'nolimit_tournament'    => undef,
                                'limit_ring'            => 'Holdem\s+Normal\s(\$.*)\/(\$.*)\s\-',
                                'potlimit_tournament'   => undef,
                                'nolimit_ring'          => 'Holdem\s+No\s+Limit\s\$(.*)\s\-',
                                'potlimit_ring'         => undef,
                                'button'                => 'Seat\s\#(.*)\sis\sthe\sdealer',
                                'hand_id'               => 'Stage\s#(\d+):',
                                'hero_hand'             => 'Dealt\sto\s(.*)\s\[(.*)\]',
                                'get_winner'            => '^(.*)\scollects\s\$*(.+)\sfrom\s(\w*)\s*pot',
                                'get_posts'             => '^(.*)\s\-\s+posts\s+(\w+ blind)\s+\$*(.*)',
                                'get_stacks'            => '^Seat\s(\d+)\s\-\s(.*)\(\$*(.*)\sin\schips\)',
                                'get_shown_cards'       => '^Seat.*:\s(\w+).*HI:.*with\s(.*)\s\[(.*)\s\-',
                                'get_rake'              => '^total\spot.*\|\srake\s\(\$(.*)\)$',
                                
                                'action'                => {
                                                               'preflop'  => '\*{3}\spocket\scards\s\*{3}(.*?)\*{3}',
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

Games::Poker::HistoryParser::Sites::Absolute::ParseRules

=head1 SYNOPSIS

 use Games::Poker::HistoryParser::Sites::Absolute::ParseRules;

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