# NAME

Regexp::NumRange - Create Regular Expressions for numeric ranges

# VERSION

version 0.04

# SYNOPSIS

    use Test::More;
    use Regexp::NumRange qw/ rx_max /;

    my $rx = rx_max(255);

    like '100', qr/^$rx$/, '100 is less than 255';
    unlike '256', qr/^$rx$/, '256 is greater tha 255';

# DESCRIPTION

__Regexp::NumRange__ is a package for generating regular expression strings. These strings can be used in a regular expression to correctly match numeric strings within only a specified range.

# FUNCTIONS

## rx\_range

Create a regex string between two arbitrary integers.

    use Test::More;
    use Regexp::NumRange qw/ rx_range /;

    my $string = rx_range(256, 1024);
    my $rx = qr/^$string$/;

    ok "10" !~ $rx;
    ok "300" =~ $rx;
    ok "2000" !~ $rx;

## rx\_max

Create a regex string between 0 and an arbitrary integer.

    my $rx_string = rx_max(1024); # create a string matching numbers between 0 and 1024
    is $rx_string, '(102[0-4]|10[0-1][0-9]|0?[0-9]{1,3})';

# EXPORT

Exports Available:

    use Regexp::NumRange qw/ rx_max rx_range /;

# SEE ALSO

[Regexp::Common::number](http://search.cpan.org/perldoc?Regexp::Common::number) - more variations, but restricted to number of digit matching

[http://dev.perl.org/perl6/rfc/197.html](http://dev.perl.org/perl6/rfc/197.html) - same goal, but for perl6!

# AUTHOR

Jacob R. Rideout <cpan@jacobrideout.net>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Jacob R. Rideout.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
