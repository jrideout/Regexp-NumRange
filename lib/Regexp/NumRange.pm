package Regexp::NumRange;

use 5.006;
use strict;
use warnings;
use Carp;
use POSIX qw( ceil );

use base 'Exporter';
our @EXPORT_OK = qw( rx_range rx_max );

=head1 NAME

Regexp::NumRange - Create Regular Expressions for numeric ranges

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

B<Regexp::NumRange> is a package for generating regular expression strings. These strings can be used in a regular expression to correctly match numeric strings within only a specified range.

Example Usage:

  use Test::More;
  use Regexp::NumRange qw/ rx_max /;

  my $rx = rx_max(255);

  like '100', /^$rx$/, '100 is less than 255';
  unlik '256', /^$rx$/, '256 is greater tha 255';

=head1 EXPORT

Exports Available:

  use Regexp::NumRange qw/ rx_max rx_range /;

=head1 SUBROUTINES/METHODS

=head2 rx_range

Not yet implemented.

=cut

sub rx_range {
    croak 'Not yet implemented.';
}

=head2 rx_max

Create a regex string between 0 and an abitrary integer.

  $rx_string = rx_max(1024); # create a string matches numbers between 0 and 1024
  print $rx_string; # print (102[0-4]|10[0-1][0-9]|0?[0-9]{1,3})

=cut

sub rx_max {
    my ($max) = @_;
    $max = int($max);
    return "[0-$max]" if $max <= 9;
    my $rx     = '(';
    my @digits = split //, "$max";
    my $after  = 0;
    while ( scalar(@digits) ) {
        $after++;
        my $d     = pop @digits;
        my $ld    = ( $after == 1 ) ? $d : $d - 1;
        my $first = scalar(@digits) ? 0 : 1;
        next if $ld < 0 && $after > 1 && !$first;
        $rx .= join( '', @digits );
        $rx .= ( $ld < 1 ) ? '0' : "[0-$ld]";
        $rx .= $first      ? '?' : '';
        $rx .= "[0-9]" if $after > 1;
        $rx .= $first ? '{1,' : '{' if $after > 2;
        $rx .= ( $after - 1 ) . '}' if $after > 2;
        $rx .= '|' unless $first;
    }
    return $rx . ')';
}

1;
__END__

=head1 SEE ALSO

L<Regexp::Common::number> - more variations, but restricted to number of digit matching

L<http://dev.perl.org/perl6/rfc/197.html> - same goal, but for perl6!

=head1 AUTHOR

Jacob R Rideout, C<< <cpan at jacobrideout.net> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-regexp-numrange at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Regexp-NumRange>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Regexp::NumRange


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Regexp-NumRange>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Regexp-NumRange>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Regexp-NumRange>

=item * Search CPAN

L<http://search.cpan.org/dist/Regexp-NumRange/>

=back


=head1 ACKNOWLEDGEMENTS

Thanks to L<Module::Install>

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Jacob R Rideout.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.


=cut

