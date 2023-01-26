package Term::Theme::Print;
use warnings;
use strict;

use base "Exporter";
our @EXPORT = qw();
our @EXPORT_OK = qw(
    print_theme
);
our %EXPORT_TAGS = (
    all => \@EXPORT_OK
);

use lib "$ENV{HOME}/git/dse.d/perl-term-theme/lib";
use lib "$ENV{HOME}/git/dse.d/perl-color-functions/lib";
use Term::Theme::Constants qw(:all);
use Term::Theme::Parser qw(:all);
use Term::Theme::Color qw(:all);

our @COLOR_NAMES = qw(
    Black
    Red
    Green
    Yellow
    Blue
    Magenta
    Cyan
    White
    BoldBlack
    BoldRed
    BoldGreen
    BoldYellow
    BoldBlue
    BoldMagenta
    BoldCyan
    BoldWhite
    ForegroundColour
    HighlightForegroundColour
    BackgroundColour
    HighlightBackgroundColour
    CursorColour
);

sub print_theme {
    my ($theme, $hs_mode) = @_;
    my $result = '';
    foreach my $color_name (@COLOR_NAMES) {
        my $rgb = $theme->{$color_name};
        next if !defined $rgb || ref $rgb ne 'ARRAY';
        if ($hs_mode) {
            $result .= sprintf("%-32s = %4.2f, %4.2f, %4.2f\n", $color_name, @$rgb);
        } else {
            $result .= sprintf("%-32s = %3d, %3d, %3d\n", $color_name, @$rgb);
        }
    }
    return $result;
}

1;
