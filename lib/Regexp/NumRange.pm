use strict;
use warnings;
package Regexp::NumRange;
# ABSTRACT: Create Regular Expressions for numeric ranges

use parent qw[Exporter];
use Carp;
use POSIX qw[ceil];

our @EXPORT_OK = qw[rx_range rx_max];

=head1 SYNOPSIS

  use Test::More;
  use Regexp::NumRange qw/ rx_max /;

  my $rx = rx_max(255);

  like '100', qr/^$rx$/, '100 is less than 255';
  unlike '256', qr/^$rx$/, '256 is greater tha 255';

=head1 DESCRIPTION

B<Regexp::NumRange> is a package for generating regular expression strings. These strings can be used in a regular expression to correctly match numeric strings within only a specified range.

=head1 EXPORT

Exports Available:

  use Regexp::NumRange qw/ rx_max rx_range /;

=cut

=func rx_range

Create a regex string between two arbitrary integers.

  use Test::More;
  use Regexp::NumRange qw/ rx_range /;

  my $string = rx_range(256, 1024);
  my $rx = qr/^$string$/;

  ok "10" !~ $rx;
  ok "300" =~ $rx;
  ok "2000" !~ $rx;

=cut

sub rx_range {
    my ( $s, $e ) = @_;
    $s = int($s);
    $e = int($e);
    ( $s, $e ) = ( $e, $s ) if $e < $s;
    return rx_max($e) if $s == 0;

    my @ds = split //, "$s";
    my @de = split //, "$e";

    my $maxd = scalar @de;
    my $mind = scalar @ds;
    my $diff = $maxd - $mind;

    my $rx = '(';

    # after last significant digit
    my @l = @de;
    my $a = 0;
    if ( $diff || $de[0] - $ds[0] >= 1 ) {
        while ( scalar(@l) >= 2 ) {
            my $d = pop @l;
            my $ld = ( $a == 0 ) ? $d : $d - 1;
            next if $ld < 0;
            $rx .= join( '', @l );
            $rx .= "[0-$ld]";
            $rx .= "[0-9]" if $a >= 1;
            $rx .= "{$a}"  if $a > 1;
            $rx .= '|';
            $a++;
        }
    }

    # counting up to common digits
    if ($diff) {
        my $min = $ds[0] + 1;
        if ( $min <= 9 ) {
            my $n = $mind - 1;
            $rx .= "[$min-9]";
            $rx .= "[0-9]{$n}" if $n >= 1;
            $rx .= '|';
        }
    }
    elsif ( $de[0] - $ds[0] > 1 ) {

        # betwixt same digit
        my $n  = $mind - 1;
        my $d1 = $ds[0] + 1;
        my $d2 = $de[0] - 1;
        $rx .= "[$d1-$d2]";
        $rx .= "[0-9]{$n}" if $n >= 1;
        $rx .= '|';
    }

    # lowest digit
    {
        my $m  = $mind - 2;
        my $l  = $ds[-1];
        my $md = ( $ds[0] == $de[0] && !$diff ) ? $de[-1] : 9;
        $rx .= join( '', @ds[ 0 .. $m ] );
        $rx .= "[$l-$md]";
        $rx .= '|';
    }

    # full middle digit ranges
    my $om = -1;
    while ( $diff > 1 ) {
        my $m = $maxd - $diff + 1;
        my $r = ( $m == $maxd - 1 ) ? $de[0] - 1 : 9;
        $diff--;
        if ( $r <= 0 ) {
            $r = 9;
            $m--;
        }
        $rx .= "[1-$r]" if $r >= 1;
        $rx .= '[0-9]';
        $rx .= "{$m}"   if $r > 1;
        $rx .= '|';
        $om = $m;
    }
    if ( $diff == 1 ) {
        my $m = $maxd - 1;
        my $r = $de[0] - 1;
        if ( $m == $om ) {
            $r = 9;
            $m = $mind;
        }
        if ( $r >= 1 ) {
            $rx .= "[1-$r]";
            $rx .= "[0-9]" if $m >= 1;
            $rx .= "{$m}" if $m > 1;
            $rx .= '|';
        }
        $m--;
    }

    $rx =~ s/\|$//;
    $rx .= ')';
    return $rx;
}

=func rx_max

Create a regex string between 0 and an arbitrary integer.

  my $rx_string = rx_max(1024); # create a string matching numbers between 0 and 1024
  is $rx_string, '(102[0-4]|10[0-1][0-9]|0?[0-9]{1,3})';

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

=head1 SEE ALSO

L<Regexp::Common::number> - more variations, but restricted to number of digit matching

L<http://dev.perl.org/perl6/rfc/197.html> - same goal, but for perl6!
