package Games::Poker::HistoryParser::Sites::PartyPoker::ParseRules;

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
                                'limit_tournament'         => 'Hold\'em[^\n]*Trny:\d+',
                                'nolimit_tournament'     => 'NL Hold\'em[^\n]*Trny:\d+',
                                'limit_ring'            => '(.*)\sHold\'em\s-\s[^\n]*?,\s\d\d:\d\d:\d\d\s',
                                'potlimit_tournament'    => 'PL Hold\'em[^\n]*Trny:\d+',
                                'nolimit_ring'            => '\$(\d+) NL Hold\'em - [^\n]*?, \d\d:\d\d:\d\d ',
                                'potlimit_ring'            => '\$(\d+) PL Hold\'em - [^\n]*?, \d\d:\d\d:\d\d ',
                                  'button'                  => 'Seat (\d+) is the button.*?\n',
                                  'hand_id'                 => '\*{5} Hand History for Game (\d+) \*{5}.*?\n',                  
                                'stakes'                => 'Stakes[ ]*\((\d+)\/(\d+)\)',
                                'level'                    => 'Level:\d+ Blinds[ ]*?\((\d+)\/(\d+)\)',
                                'bb_size'                => 'posts big blind \((\d+\.\d+|\d+)\)',                                
                                'hero_hand'             => 'Dealt to (\w+) \[\s+(\d|T|J|Q|K|A)(c|d|h|s)\s+(\d|T|J|Q|K|A)(c|d|h|s)\s+\]',
                                'check_winner'            => '(\w+)\s+wins',
                                'get_winner'            => '(\w+)\s+wins\s+\$(.+)\s+from\s+(the\s+)*(\w+)\s+pot',
                                'get_winner_alt'        => '(\w+)\s+wins\s+\$(.+)',
                                'get_posts'                => '^(.*)\s+posts\s+(\w+ blind)\s+\[\$(.*)\]',
                                'get_stacks'            => 'Seat (\d+):\s(\w+)\s\(\s\$(.+)\s\)',
                                'get_shown_cards'        => '(\w+)\s+(shows|doesn\'t show)\s+\[\s+(\d|T|J|Q|K|A)(c|d|h|s),\s+(\d|T|J|Q|K|A)(c|d|h|s)\s+\]\s+(.+)\.',
                                   'action'                => '\*\* Dealing down cards \*\*(.*)\*\* Dealing Flop \*\*\s+\[(.+?)\](.*)\*\* Dealing Turn \*\*\s+\[(.+?)\](.*)\*\* Dealing River \*\*\s+\[(.+?)\](.*)',
                               },
                    oh     => { 
                                'limit_tournament'         => 'Omama[^\n]*Trny:\d+',
                                'nolimit_tournament'     => 'NL Omaha[^\n]*Trny:\d+',
                                'limit_ring'            => '\$(\d+|\d+\.\d+)\/\$(\d+|\d+\.\d+)\sOmaha\s\-\s[^\n]*?,\s\d\d:\d\d:\d\d\s',
                                'potlimit_tournament'    => 'PL Omaha[^\n]*Trny:\d+',
                                'nolimit_ring'            => '\$(\d+)\sNL\sOmaha\s\-\s[^\n]*?,\s\d\d:\d\d:\d\d\s',
                                'potlimit_ring'            => '\$(\d+)\sPL\sOmaha\s\-\s[^\n]*?,\s\d\d:\d\d:\d\d\s',
                                  'button'                  => 'Seat (\d+) is the button.*?\n/\n',
                                  'hand_id'                 => '\*{5} Hand History for Game (\d+) \*{5}.*?\n',                  
                                'stakes'                => 'Stakes[ ]*\((\d+)\/(\d+)\)',
                                'level'                    => 'Level:\d+ Blinds[ ]*?\((\d+)\/(\d+)\)',
                                'bb_size'                => 'posts\sbig\sblind\s\((\d+\.\d+|\d+)\)',                                
                                'hero_hand'             => 'Dealt to (\w+) \[\s+(\d|T|J|Q|K|A)(c|d|h|s)\s+(\d|T|J|Q|K|A)(c|d|h|s)\s+(\d|T|J|Q|K|A)(c|d|h|s)\s+(\d|T|J|Q|K|A)(c|d|h|s)\s+\]',
                                'check_winner'            => '(\w+)\s+wins',
                                'get_winner'            => '(\w+)\s+wins\s+\$(.+)\s+from\s+the\s+(\w+)',
                                'get_winner_alt'        => '(\w+)\s+wins\s+\$(.+)',                                
                                'get_posts'                => '^(.*)\s+posts\s+(\w+ blind)\s+\[\$(.*)\]',
                                'get_stacks'            => 'Seat\s(\d+):\s(\w+)\s\(\s\$(.+)\s\)',
                                'get_shown_cards'        => '(\w+)\s+shows\s+\[\s+(\d|T|J|Q|K|A)(c|d|h|s),\s+(\d|T|J|Q|K|A)(c|d|h|s)\s+(\d|T|J|Q|K|A)(c|d|h|s)\s+(\d|T|J|Q|K|A)(c|d|h|s)\s+\]\s+(.+)\.',
                                   'action'                => '\*\*\sDealing\sdown\scards\s\*\*(.*)\*\*\sDealing Flop\s\*\*\s+\[(.+?)\](.*)\*\*\sDealing\sTurn\s\*\*\s+\[(.+?)\](.*)\*\*\sDealing\sRiver\s\*\*\s+\[(.+?)\](.*)',
                               },                               
                  );

    return $rules{ lc $type };                      
}
    
1;

__END__

=head1 NAME

Games::Poker::HistoryParser::Sites::PartyPoker::ParseRules

=head1 SYNOPSIS

 use Games::Poker::HistoryParser::Sites::PartyPoker::ParseRules;

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