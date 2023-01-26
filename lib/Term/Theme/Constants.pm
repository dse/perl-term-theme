package Term::Theme::Constants;
use warnings;
use strict;

use base "Exporter";
our @EXPORT = qw();
our @EXPORT_OK = (
    'TERM_THEME_BLK',
    'TERM_THEME_RED',
    'TERM_THEME_GRN',
    'TERM_THEME_YEL',
    'TERM_THEME_BLU',
    'TERM_THEME_MGN',
    'TERM_THEME_CYN',
    'TERM_THEME_WHT',
    'TERM_THEME_HI_BLK',
    'TERM_THEME_HI_RED',
    'TERM_THEME_HI_GRN',
    'TERM_THEME_HI_YEL',
    'TERM_THEME_HI_BLU',
    'TERM_THEME_HI_MGN',
    'TERM_THEME_HI_CYN',
    'TERM_THEME_HI_WHT',
    'TERM_THEME_FG',
    'TERM_THEME_HI_FG',
    'TERM_THEME_BG',
    'TERM_THEME_HI_BG',
    'TERM_THEME_CURSOR',
    'is_chromatic',
    'is_achromatic',
);
our %EXPORT_TAGS = (all => \@EXPORT_OK);

# https://mgsweb2.mngs.umn.edu/cwi_doc/color.asp
# color abbreviations

use constant TERM_THEME_BLK    => 'Black';
use constant TERM_THEME_RED    => 'Red';
use constant TERM_THEME_GRN    => 'Green';
use constant TERM_THEME_YEL    => 'Yellow';
use constant TERM_THEME_BLU    => 'Blue';
use constant TERM_THEME_MGN    => 'Magenta';
use constant TERM_THEME_CYN    => 'Cyan';
use constant TERM_THEME_WHT    => 'White';
use constant TERM_THEME_HI_BLK => 'BoldBlack';
use constant TERM_THEME_HI_RED => 'BoldRed';
use constant TERM_THEME_HI_GRN => 'BoldGreen';
use constant TERM_THEME_HI_YEL => 'BoldYellow';
use constant TERM_THEME_HI_BLU => 'BoldBlue';
use constant TERM_THEME_HI_MGN => 'BoldMagenta';
use constant TERM_THEME_HI_CYN => 'BoldCyan';
use constant TERM_THEME_HI_WHT => 'BoldWhite';
use constant TERM_THEME_FG     => 'ForegroundColour';
use constant TERM_THEME_HI_FG  => 'HighlightForegroundColour';
use constant TERM_THEME_BG     => 'BackgroundColour';
use constant TERM_THEME_HI_BG  => 'HighlightBackgroundColour';
use constant TERM_THEME_CURSOR => 'CursorColour';

our %CHROMATIC = (
    (TERM_THEME_BLK) => 1,
    (TERM_THEME_RED) => 1,
    (TERM_THEME_GRN) => 1,
    (TERM_THEME_YEL) => 1,
    (TERM_THEME_BLU) => 1,
    (TERM_THEME_MGN) => 1,
    (TERM_THEME_CYN) => 1,
    (TERM_THEME_WHT) => 1,
    (TERM_THEME_HI_BLK) => 1,
    (TERM_THEME_HI_RED) => 1,
    (TERM_THEME_HI_GRN) => 1,
    (TERM_THEME_HI_YEL) => 1,
    (TERM_THEME_HI_BLU) => 1,
    (TERM_THEME_HI_MGN) => 1,
    (TERM_THEME_HI_CYN) => 1,
    (TERM_THEME_HI_WHT) => 1,
);

our %ACHROMATIC = (
    (TERM_THEME_FG) => 1,
    (TERM_THEME_HI_FG) => 1,
    (TERM_THEME_BG) => 1,
    (TERM_THEME_HI_BG) => 1,
    (TERM_THEME_CURSOR) => 1,
);

sub is_chromatic {
    my $color = shift;
    return $CHROMATIC{$color};
}

sub is_achromatic {
    my $color = shift;
    return $ACHROMATIC{$color};
}

1;
