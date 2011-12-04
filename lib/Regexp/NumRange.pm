package Regexp::NumRange;

use 5.005;
use strict;
use warnings;
use Carp;
use POSIX qw( ceil );

use base 'Exporter';
our @EXPORT_OK = qw( rx_range rx_max );
our $VERSION   = '0.10';

=head1 NAME

Regexp::NumRange - Create Regular Expressions for numeric ranges

=head1 SYNOPSIS

Example Usage:

  use Test::More;
  use Regexp::NumRange qw/ rx_max /;
  
  my $rx = rx_max(255);
  
  like '100', /^$rx$/, '100 is less than 255';
  unlik '256', /^$rx$/, '256 is greater tha 255';

=head1 DESCRIPTION

B<Regexp::NumRange> is a package for generating regular expression strings. These strings can be used in a regular expression to correctly match numeric strings within only a specified range.

=head1 How it Works

  $rx_string = rx_max(1024); # create a string matches numbers between 0 and 1024
  print $rx_string; # print 

=cut

sub rx_range {
    croak 'Not yet implemented.';
}

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
        my $ld  = ( $after == 1 ) ? $d : $d - 1;
        my $first = scalar(@digits) ? 0 : 1;
        next if $ld < 0 && $after > 1 && !$first;
        $rx .= join( '', @digits );
        $rx .= ( $ld < 1 ) ? '0' : "[0-$ld]";
        $rx .= $first        ? '?' : '';
        $rx .= "[0-9]" if $after > 1;
        $rx .= $first ? '{1,' : '{' if $after > 2;
        $rx .= ( $after - 1 ) . '}' if $after > 2;
        $rx .= '|' unless $first;
    }
    return $rx . ')';
}

1;
__END__

=back

=head1 SEE ALSO

L<Regext::Common>

=head1 AUTHORS

Jacob Rideout E<lt>cpan@jacobrideout.net<gt>

=head1 COPYRIGHT

Copyright 2011 Jacob Rideout

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

