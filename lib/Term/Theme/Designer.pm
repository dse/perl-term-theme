package Term::Theme::Designer;
use warnings;
use strict;
use Data::Dumper qw(Dumper);

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
    my $normal_lightness       = $options{normal_lightness}       // 0.2; # 0..1
    my $bright_lightness       = $options{bright_lightness}       // 0.7; # 0..1
    my $black_lightness        = $options{black_lightness}        // 0; # chromatic blk
    my $bright_black_lightness = $options{bright_black_lightness} // 0.1; # chromatic bright blk
    my $white_lightness        = $options{white_lightness}        // 0.4; # chromatic wht
    my $bright_white_lightness = $options{bright_white_lightness} // 1; # chromatic bright wht
    my $dye_color              = $options{dye_color}              // [0, 0, 0];
    my $dye_opacity            = $options{dye_opacity}            // 0;
    my $dye_chromatics         = $options{dye_chromatics}         // 0; # flag
    my $dye_achromatics        = $options{dye_achromatics}        // 0; # flag
    my $background             = $options{background}             // [0, 0, 0];
    my $foreground             = $options{foreground}             // [0, 0, 0.5];
    my $bright_background      = $options{bright_background}      // [0, 0, 0.25];
    my $bright_foreground      = $options{bright_foreground}      // [0, 0, 1];
    my $cursor_color           = $options{cursor_color}           // [1/6, 1, 0.5];
    my $colorspace             = $options{colorspace}             // 'hsl';
    my $no_gamma               = $options{no_gamma} // 0;
    my $no_zero_to_one         = $options{no_zero_to_one} // 0;
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
    my $hex = sub {
        my ($hsx) = @_;
        return colorspace_to_srgb_hex($colorspace, $hsx);
    };
    my $theme = {
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
    $theme->{'@COMMENTS'} = [
        sprintf('hue shift:              %.5f', $hue_shift),
        sprintf('saturation:             %.5f', $saturation),
        sprintf('normal lightness:       %.5f', $normal_lightness),
        sprintf('bright lightness:       %.5f', $bright_lightness),
        sprintf('black lightness:        %.5f', $black_lightness),
        sprintf('bright black lightness: %.5f', $bright_black_lightness),
        sprintf('white lightness:        %.5f', $white_lightness),
        sprintf('bright white lightness: %.5f', $bright_white_lightness),
        sprintf('dye color:              %s(%.5f, %.5f, %.5f) %s', $colorspace, @{$dye_color}, $hex->(($dye_color))),
        sprintf('dye opacity:            %.5f', $dye_opacity),
        sprintf('dye chromatics?:        %s', $dye_chromatics ? 'true' : 'false'),
        sprintf('dye achromatics?:       %s', $dye_achromatics ? 'true' : 'false'),
        sprintf('background:             %s(%.5f, %.5f, %.5f) %s', $colorspace, @{$background}, $hex->(($background))),
        sprintf('foreground:             %s(%.5f, %.5f, %.5f) %s', $colorspace, @{$foreground}, $hex->(($foreground))),
        sprintf('bright background:      %s(%.5f, %.5f, %.5f) %s', $colorspace, @{$bright_background}, $hex->(($bright_background))),
        sprintf('bright foreground:      %s(%.5f, %.5f, %.5f) %s', $colorspace, @{$bright_foreground}, $hex->(($bright_foreground))),
        sprintf('cursor color:           %s(%.5f, %.5f, %.5f) %s', $colorspace, @{$cursor_color}, $hex->(($cursor_color))),
        sprintf('colorspace:             %s', $colorspace),
    ];
    $theme->{'@SUMMARY'} = [
        sprintf('colors: blk %s red %s grn %s yel %s blu %s mgn %s cyn %s wht %s', (map { $hex->(($theme->{$_})) } qw(Black Red Green Yellow Blue Magenta Cyan White))),
        sprintf('bright: blk %s red %s grn %s yel %s blu %s mgn %s cyn %s wht %s', (map { $hex->(($theme->{$_})) } qw(BoldBlack BoldRed BoldGreen BoldYellow BoldBlue BoldMagenta BoldCyan BoldWhite))),
        sprintf('fg: %s   bg: %s   bright fg: %s   bright bg: %s   cursor: %s ', (map { $hex->(($theme->{$_})) } qw(ForegroundColour
                                                                                                                    BackgroundColour
                                                                                                                    HighlightForegroundColour
                                                                                                                    HighlightBackgroundColour
                                                                                                                    CursorColour))),
    ];
    my $dye_rgb = colorspace_to_linear($colorspace, $dye_color);
    foreach my $color (keys %$theme) {
        next if substr($color, 0, 1) eq '@';
        my $use_dye = 0;
        if (is_achromatic($color)) {
            $use_dye = $dye_achromatics;
        }
        if (is_chromatic($color)) {
            $use_dye = $dye_chromatics;
        }
        $theme->{$color} = colorspace_to_linear($colorspace, $theme->{$color});
        if ($use_dye) {
            $theme->{$color} = [linear_color_mix($theme->{$color}, $dye_rgb, $dye_opacity)];
        }
        $theme->{$color} = linear_to_srgb($theme->{$color});
        $theme->{$color} = multiply_255($theme->{$color});
    }
    return $theme;
}

sub colorspace_to_linear {
    my ($colorspace, $h, $s, $x) = @_;
    return hsl_to_linear($h, $s, $x) if $colorspace eq 'hsl';
    return hsv_to_linear($h, $s, $x) if $colorspace eq 'hsv';
    return hsi_to_linear($h, $s, $x) if $colorspace eq 'hsi';
    return hsp_to_linear($h, $s, $x) if $colorspace eq 'hsp';
}

sub colorspace_to_srgb_hex {
    my ($colorspace, $h, $s, $x) = @_;
    my $srgb;
    $srgb = hsl_to_srgb($h, $s, $x) if $colorspace eq 'hsl';
    $srgb = hsv_to_srgb($h, $s, $x) if $colorspace eq 'hsv';
    $srgb = hsi_to_srgb($h, $s, $x) if $colorspace eq 'hsi';
    $srgb = hsp_to_srgb($h, $s, $x) if $colorspace eq 'hsp';
    return srgb_hex(multiply_255($srgb));
}

1;
