#!perl

use strict;
use warnings;
use Test::More;

unless ( $ENV{RELEASE_TESTING} ) {
    plan( skip_all => "Author tests not required for installation" );
}
eval "use Test::Spelling";
exit if $@;
add_stopwords(<DATA>);
all_pod_files_spelling_ok();

__END__
Rideout
CPAN
AnnoCPAN
