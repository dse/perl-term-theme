package Term::Theme::Parser;
use warnings;
use strict;

use lib "$ENV{HOME}/git/dse.d/perl-term-theme/lib";
use lib "$ENV{HOME}/git/dse.d/perl-color-functions/lib";
use Term::Theme::Color qw(:all);

sub new {
    my ($class, %args) = @_;
    my $self = bless(\%args, $class);
    return $self;
}
sub parse_line {
    warn("parse_line\n");
    my ($self, $line) = @_;
    local $_ = $line;
    s{\A\s*}{}s;
    s{\s*\z}{}s;
    return if m{^\s*#};
    return unless  m{^\s*(?<name>\S.*?)
                     \s*=\s*
                     (?<red>\d+)
                     \s*,\s*
                     (?<green>\d+)
                     \s*,\s*
                     (?<blue>\d+)
                     \s*$}x;
    my ($color, $red, $green, $blue) = @+{qw(name red green blue)};
    $_ = clamp($_, 0, 255) foreach ($red, $green, $blue);
    if ($self->{callback}) {
        $self->{callback}->($color, $red / 255, $green / 255, $blue / 255);
    }
}
sub eof {
    my ($self) = @_;
    # placeholder
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
