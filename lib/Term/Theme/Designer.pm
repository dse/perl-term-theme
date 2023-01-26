package Term::Theme::Designer;
use warnings;
use strict;

use base "Exporter";
our @EXPORT = qw();
our @EXPORT_OK = (
    'design_theme',
);
our %EXPORT_TAGS = (all => \@EXPORT_OK);

use lib "$ENV{HOME}/git/dse.d/perl-term-theme/lib";
use lib "$ENV{HOME}/git/dse.d/perl-color-functions/lib";
use Color::Functions qw(:all);
use Term::Theme::Constants qw(:all);
use Term::Theme::Print qw(:all);

# based on https://ciembor.github.io/4bit/
#          https://github.com/ciembor/4bit
# has adjustments for:
#     - global property hue,        affecting red/yel/grn/cyn/blu/mgn [*]
#     - global property saturation, affecting red/yel/grn/cyn/blu/mgn [*]
# under lightness:
#     - normal lightness, affects normal colors red/yel/grn/cyn/blu/mgn [*]
#     - bright lightness, affects bright colors [*]
# for black:
#     - normal lightness, affects blk [*]
#     - bright lightness [*]
# for white:
#     - normal lightness, affects wht [*]
#     - bright lightness [*]
# under advanced:
#     - dye
#         - color selector
#             - hue, saturation, lightness, alpha
#         - affects: none, achromatic, color, all
#             - chromatics are:
#             - achromatics are: black, bright black, white, bright white
#     - background
#         - can be: custom color (using colorpicker), black, bright_black, white, bright_white
#     - foreground
#         - can be: custom color (using colorpicker), black, bright_black, white, bright_white

sub design_theme {
    my %options = @_;
    my $hue_shift              = $options{hue_shift}              // 0; # -1/12..1/12 (-30..30 degrees)
    my $saturation             = $options{saturation}             // 1; # 0..1
    my $normal_lightness       = $options{normal_lightness}       // 0.4; # 0..1
    my $bright_lightness       = $options{bright_lightness}       // 0.6; # 0..1
    my $black_lightness        = $options{black_lightness}        // 0; # chromatic blk
    my $bright_black_lightness = $options{bright_black_lightness} // 0.15; # chromatic bright blk
    my $white_lightness        = $options{white_lightness}        // 0.85; # chromatic wht
    my $bright_white_lightness = $options{bright_white_lightness} // 1; # chromatic bright wht
    my $dye_color              = $options{dye_color}              // [0, 0, 0];
    my $dye_opacity            = $options{dye_opacity}            // 0;
    my $dye_chromatics         = $options{dye_chromatics}         // 0; # flag
    my $dye_achromatics        = $options{dye_achromatics}        // 0; # flag
    my $background             = $options{background}             // [0, 0, 0];
    my $foreground             = $options{foreground}             // [0, 0, 0.85];
    my $bright_background      = $options{bright_background};
    my $bright_foreground      = $options{bright_foreground};
    my $cursor_color           = $options{cursor_color}           // [1/6, 1, 0.5];
    if (!defined $bright_background) {
        $bright_background = [ @{$background} ];
        $bright_background->[2] += 0.15;
    }
    if (!defined $bright_foreground) {
        $bright_foreground = [ @{$foreground} ];
        $bright_foreground->[2] += 0.15;
    }
    my $red              = [0/6 + $hue_shift, $saturation, $normal_lightness];
    my $yellow           = [1/6 + $hue_shift, $saturation, $normal_lightness];
    my $green            = [2/6 + $hue_shift, $saturation, $normal_lightness];
    my $cyan             = [3/6 + $hue_shift, $saturation, $normal_lightness];
    my $blue             = [4/6 + $hue_shift, $saturation, $normal_lightness];
    my $magenta          = [5/6 + $hue_shift, $saturation, $normal_lightness];
    my $bright_red       = [0/6 + $hue_shift, $saturation, $bright_lightness];
    my $bright_yellow    = [1/6 + $hue_shift, $saturation, $bright_lightness];
    my $bright_green     = [2/6 + $hue_shift, $saturation, $bright_lightness];
    my $bright_cyan      = [3/6 + $hue_shift, $saturation, $bright_lightness];
    my $bright_blue      = [4/6 + $hue_shift, $saturation, $bright_lightness];
    my $bright_magenta   = [5/6 + $hue_shift, $saturation, $bright_lightness];
    my $black            = [0, 0, $black_lightness];
    my $white            = [0, 0, $white_lightness];
    my $bright_black     = [0, 0, $bright_black_lightness];
    my $bright_white     = [0, 0, $bright_white_lightness];
    my $convert = sub {
        my $hsl = shift;
        my $rgb = hsl_to_linear($hsl);
        my $srgb = linear_to_srgb($rgb);
        $srgb = multiply_255($srgb);
        return $srgb;
    };
    my $new_theme = {
        Black                     => $black,
        Red                       => $red,
        Green                     => $green,
        Yellow                    => $yellow,
        Blue                      => $blue,
        Magenta                   => $magenta,
        Cyan                      => $cyan,
        White                     => $white,
        BoldBlack                 => $bright_black,
        BoldRed                   => $bright_red,
        BoldGreen                 => $bright_green,
        BoldYellow                => $bright_yellow,
        BoldBlue                  => $bright_blue,
        BoldMagenta               => $bright_magenta,
        BoldCyan                  => $bright_cyan,
        BoldWhite                 => $bright_white,
        ForegroundColour          => $foreground,
        HighlightForegroundColour => $bright_foreground,
        BackgroundColour          => $background,
        HighlightBackgroundColour => $bright_background,
        CursorColour              => $cursor_color,
    };
    warn(print_theme($new_theme, 1));
    foreach my $color (keys %$new_theme) {
        my $use_dye = 0;
        if (is_achromatic($color)) {
            $use_dye = $dye_achromatics;
        }
        if (is_chromatic($color)) {
            $use_dye = $dye_chromatics;
        }
        if ($use_dye) {
            $new_theme->{$color} = [color_mix($new_theme->{$color}, $dye_color, $dye_opacity)];
        }
    }
    warn(print_theme($new_theme, 1));
    foreach my $color (keys %$new_theme) {
        $new_theme->{$color} = $convert->($new_theme->{$color});
    }
    return $new_theme;
}

1;
