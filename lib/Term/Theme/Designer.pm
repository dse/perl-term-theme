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

sub design_theme {
    my %args = @_;
    my $designer = __PACKAGE__->new(%args);
    return $designer->design();
}

our %DEFAULTS;
BEGIN {
};

sub new {
    my ($class, %args) = @_;
    my $self = bless(\%args, $class);

    $self->{hue_shift}              //= 0;
    $self->{saturation}             //= 1;

    $self->{black_lightness}        //= 0;
    $self->{bright_black_lightness} //= 0.2;

    $self->{normal_lightness}       //= 0.4;
    $self->{bright_lightness}       //= 0.6;

    $self->{white_lightness}        //= 0.8;
    $self->{bright_white_lightness} //= 1;

    $self->{dye_color}              //= [0, 0, 0.25];
    $self->{dye_opacity}            //= 0;
    $self->{dye_chromatics}         //= 0;
    $self->{dye_achromatics}        //= 0;
    $self->{background}             //= [0, 0, 0];
    $self->{foreground}             //= [0, 0, 0.85];
    $self->{bright_background}      //= [0, 0, 0.15];
    $self->{bright_foreground}      //= [0, 0, 1];

    $self->{cursor_color}           //= [1/6, 1, 0.5];
    $self->{colorspace}             //= 'hsl';
    $self->{no_gamma}               //= 0;
    $self->{no_zero_to_one}         //= 0;

    return $self;
}

sub design {
    my ($self) = @_;
    my $hue_shift              = $self->{hue_shift};
    my $saturation             = $self->{saturation};
    my $black_lightness        = $self->{black_lightness};
    my $bright_black_lightness = $self->{bright_black_lightness};
    my $normal_lightness       = $self->{normal_lightness};
    my $bright_lightness       = $self->{bright_lightness};
    my $white_lightness        = $self->{white_lightness};
    my $bright_white_lightness = $self->{bright_white_lightness};
    my $dye_color              = $self->{dye_color};
    my $dye_opacity            = $self->{dye_opacity};
    my $dye_chromatics         = $self->{dye_chromatics};
    my $dye_achromatics        = $self->{dye_achromatics};
    my $background             = $self->{background};
    my $foreground             = $self->{foreground};
    my $bright_background      = $self->{bright_background};
    my $bright_foreground      = $self->{bright_foreground};
    my $cursor_color           = $self->{cursor_color};
    my $colorspace             = $self->{colorspace};
    my $no_gamma               = $self->{no_gamma};
    my $no_zero_to_one         = $self->{no_zero_to_one};

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
    my $dye_rgb = $self->colorspace_to_linear($dye_color);
    foreach my $color (keys %$theme) {
        my $debug = 1; # $color eq 'BoldWhite' || $color eq 'BoldYellow';
        next if substr($color, 0, 1) eq '@';
        my $use_dye = 0;
        if (is_achromatic($color)) {
            $use_dye = $dye_achromatics;
        }
        if (is_chromatic($color)) {
            $use_dye = $dye_chromatics;
        }
        printf STDERR ("%s [%.2f %.2f %.2f]", $color, @{$theme->{$color}}) if $debug;
        $theme->{$color} = $self->colorspace_to_linear($theme->{$color});
        printf STDERR (" => [%.2f %.2f %.2f]", @{$theme->{$color}}) if $debug;
        if ($use_dye) {
            $theme->{$color} = [linear_color_mix($theme->{$color}, $dye_rgb, $dye_opacity)];
            printf STDERR (" => mix => [%.2f %.2f %.2f]", @{$theme->{$color}}) if $debug;
        }
        if (!$self->{no_gamma}) {
            $theme->{$color} = linear_to_srgb($theme->{$color});
            printf STDERR (" => gamma => [%.2f %.2f %.2f]", @{$theme->{$color}}) if $debug;
        }
        $theme->{$color} = multiply_255($theme->{$color});
        printf STDERR (" => multiply_255 => [%d %d %d]\n", @{$theme->{$color}}) if $debug;
    }
    my $hsx_hex = sub {
        my ($h, $s, $x) = @_;
        return $self->colorspace_to_srgb_hex($h, $s, $x);
    };
    my $rgb_hex = sub {
        my ($r, $g, $b) = @_;
        return sprintf("#%02x%02x%02x", $r, $g, $b);
    };
    $theme->{'@COMMENTS'} = [
        sprintf("hue_shift  %5.2f (%3d degrees)", $hue_shift, $hue_shift * 360),
        sprintf("saturation %5.2f", $saturation),
        sprintf("lightness  black %5.2f bright black %5.2f", $black_lightness, $bright_black_lightness),
        sprintf("lightness  color %5.2f bright color %5.2f", $normal_lightness, $bright_lightness),
        sprintf("lightness  white %5.2f bright white %5.2f", $white_lightness, $bright_white_lightness),
        sprintf("dye_color  [%.2f, %.2f, %.2f] opacity %5.2f", @$dye_color, $dye_opacity),
        sprintf("background [%.2f, %.2f, %.2f] %s", @$background, $hsx_hex->(@$background)),
        sprintf("foreground [%.2f, %.2f, %.2f] %s", @$foreground, $hsx_hex->(@$foreground)),
        sprintf(" bright bg [%.2f, %.2f, %.2f] %s", @$bright_background, $hsx_hex->(@$bright_background)),
        sprintf(" bright fg [%.2f, %.2f, %.2f] %s", @$bright_foreground, $hsx_hex->(@$bright_foreground)),
        sprintf("cursor     [%.2f, %.2f, %.2f] %s", @$cursor_color, $hsx_hex->(@$cursor_color)),
        sprintf("colorspace %s", $colorspace),
        sprintf("no gamma?  %s", $no_gamma ? 'yes' : 'no'),
        sprintf("normal blk %s bright blk %s", $rgb_hex->(@{$theme->{Black}}), $rgb_hex->(@{$theme->{BoldBlack}})),
        sprintf("       red %s        red %s", $rgb_hex->(@{$theme->{Red}}), $rgb_hex->(@{$theme->{BoldRed}})),
        sprintf("       grn %s        grn %s", $rgb_hex->(@{$theme->{Green}}), $rgb_hex->(@{$theme->{BoldGreen}})),
        sprintf("       yel %s        yel %s", $rgb_hex->(@{$theme->{Yellow}}), $rgb_hex->(@{$theme->{BoldYellow}})),
        sprintf("       blu %s        blu %s", $rgb_hex->(@{$theme->{Blue}}), $rgb_hex->(@{$theme->{BoldBlue}})),
        sprintf("       mgn %s        mgn %s", $rgb_hex->(@{$theme->{Magenta}}), $rgb_hex->(@{$theme->{BoldMagenta}})),
        sprintf("       cyn %s        cyn %s", $rgb_hex->(@{$theme->{Cyan}}), $rgb_hex->(@{$theme->{BoldCyan}})),
        sprintf("       wht %s        wht %s", $rgb_hex->(@{$theme->{White}}), $rgb_hex->(@{$theme->{BoldWhite}})),
    ];
    $theme->{'@SUMMARY'} = [
    ];
    return $theme;
}
sub colorspace_to_linear {
    my ($self, $h, $s, $x) = @_;
    my $colorspace = $self->{colorspace};
    return hsl_to_linear($h, $s, $x) if $colorspace eq 'hsl';
    return hsv_to_linear($h, $s, $x) if $colorspace eq 'hsv';
    return hsi_to_linear($h, $s, $x) if $colorspace eq 'hsi';
    return hsp_to_linear($h, $s, $x) if $colorspace eq 'hsp';
}

sub colorspace_to_srgb_hex {
    my ($self, $h, $s, $x) = @_;
    my $colorspace = $self->{colorspace};
    my $gamma = !$self->{no_gamma};
    my @linear = $self->colorspace_to_linear($h, $s, $x);
    if ($gamma) {
        @linear = linear_to_srgb(@linear);
    }
    @linear = multiply_255(@linear);
    return sprintf("#%02x%02x%02x", @linear);
}

1;
