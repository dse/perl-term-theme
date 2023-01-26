package Term::Theme::Setter;
use warnings;
use strict;
use POSIX qw(round);

use base "Exporter";
our @EXPORT = qw();
our @EXPORT_OK = qw(set_color);
our %EXPORT_TAGS = (all => \@EXPORT_OK);

our $ST = "\e\\";               # string terminator
our $OSC = "\e]";               # operating system command

use lib "$ENV{HOME}/git/dse.d/perl-term-theme/lib";
use lib "$ENV{HOME}/git/dse.d/perl-color-functions/lib";
use Term::Theme::Constants qw(:all);

our %COLOR_NUMBERS = (
    (TERM_THEME_BLK)    => '4;0',
    (TERM_THEME_RED)    => '4;1',
    (TERM_THEME_GRN)    => '4;2',
    (TERM_THEME_YEL)    => '4;3',
    (TERM_THEME_BLU)    => '4;4',
    (TERM_THEME_MGN)    => '4;5',
    (TERM_THEME_CYN)    => '4;6',
    (TERM_THEME_WHT)    => '4;7',
    (TERM_THEME_HI_BLK) => '4;8',
    (TERM_THEME_HI_RED) => '4;9',
    (TERM_THEME_HI_GRN) => '4;10',
    (TERM_THEME_HI_YEL) => '4;11',
    (TERM_THEME_HI_BLU) => '4;12',
    (TERM_THEME_HI_MGN) => '4;13',
    (TERM_THEME_HI_CYN) => '4;14',
    (TERM_THEME_HI_WHT) => '4;15',
    (TERM_THEME_FG)     => '10',
    (TERM_THEME_HI_FG)  => '17',
    (TERM_THEME_BG)     => '11',
    (TERM_THEME_HI_BG)  => '19',
    (TERM_THEME_CURSOR) => '12',
);

# print join(", ", sort { $a <=> $b } keys %COLOR_NUMBERS), "\n";

sub set_color {
    my ($color, $red, $green, $blue) = @_;
    $red   = round(clamp($red)   * 255);
    $green = round(clamp($green) * 255);
    $blue  = round(clamp($blue)  * 255);
    my $srgb_color = sprintf("#%02x%02x%02x", $red, $green, $blue);
    return $OSC . $COLOR_NUMBERS{$color} . ';' . $srgb_color . $ST;
}

sub clamp {
    my ($x, $min, $max) = @_;
    if (!defined $min && !defined $max) {
        ($min, $max) = (0, 1);
    }
    $min //= '-Inf' + 0;
    $max //= 'Inf' + 0;
    return $x < $min ? $min : $x > $max ? $max : $x;
}

1;
