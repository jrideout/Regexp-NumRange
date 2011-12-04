# NAME

Regexp::NumRange - Create Regular Expressions for numeric ranges

# VERSION

Version 0.01

# SYNOPSIS

__Regexp::NumRange__ is a package for generating regular expression strings. These strings can be used in a regular expression to correctly match numeric strings within only a specified range.

Example Usage:

    use Test::More;
    use Regexp::NumRange qw/ rx_max /;

    my $rx = rx_max(255);

    like '100', /^$rx$/, '100 is less than 255';
    unlik '256', /^$rx$/, '256 is greater tha 255';

# EXPORT

Exports Available:

    use Regexp::NumRange qw/ rx_max rx_range /;

# SUBROUTINES/METHODS

## rx_range

Not yet implemented.

## rx_max

Create a regex string between 0 and an abitrary integer.

    $rx_string = rx_max(1024); # create a string matches numbers between 0 and 1024
    print $rx_string; # print (102[0-4]|10[0-1][0-9]|0?[0-9]{1,3})

# SEE ALSO

[Regexp::Common](http://search.cpan.org/perldoc?Regexp::Common)

# AUTHOR

Jacob R Rideout, `<cpan at jacobrideout.net>`

# BUGS

Please report any bugs or feature requests to `bug-regexp-numrange at rt.cpan.org`, or through
the web interface at [http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Regexp-NumRange](http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Regexp-NumRange).  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.



# SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Regexp::NumRange



You can also look for information at:

- RT: CPAN's request tracker (report bugs here)

[http://rt.cpan.org/NoAuth/Bugs.html?Dist=Regexp-NumRange](http://rt.cpan.org/NoAuth/Bugs.html?Dist=Regexp-NumRange)

- AnnoCPAN: Annotated CPAN documentation

[http://annocpan.org/dist/Regexp-NumRange](http://annocpan.org/dist/Regexp-NumRange)

- CPAN Ratings

[http://cpanratings.perl.org/d/Regexp-NumRange](http://cpanratings.perl.org/d/Regexp-NumRange)

- Search CPAN

[http://search.cpan.org/dist/Regexp-NumRange/](http://search.cpan.org/dist/Regexp-NumRange/)



# ACKNOWLEDGEMENTS

Thanks to [Module::Install](http://search.cpan.org/perldoc?Module::Install)

# LICENSE AND COPYRIGHT

Copyright 2011 Jacob R Rideout.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See [http://dev.perl.org/licenses/](http://dev.perl.org/licenses/) for more information.

