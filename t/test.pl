package My::Class;
use warnings;
use strict;

our @qw1 = qw(one
              two
              three
);
our @qw2 = qw(
    one
    two
    three
);
our @list1 = (1, 2,
              3, 4);
our @list2 = (1, 2,
              3, 4
);
our @list3 = (
    1, 2,
    3, 4
);
our %hash1 = (a => 1, b => 2,
              c => 3, d => 4);
our %hash2 = (a => 1, b => 2,
              c => 3, d => 4,
);
our %hash3 = (
    a => 1, b => 2,
    c => 3, d => 4,
);
our $list1 = [1, 2,
              3, 4];
our $list2 = [1, 2,
              3, 4
];
our $list3 = [
    1, 2,
    3, 4
];
our $hash1 = {a => 1, b => 2,
              c => 3, d => 4};
our $hash2 = {a => 1, b => 2,
              c => 3, d => 4,
};
our $hash3 = {
    a => 1, b => 2,
    c => 3, d => 4,
};
1;
