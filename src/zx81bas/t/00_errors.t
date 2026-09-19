BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;
use Data::Dump 'dump';

# collect all code error messages
my %code_errors;
@ARGV = <*.cpp>;
while (<>) {
    if (/error\(.*?"(.*?)"/) {
        my $message = $1;
        unlike $message, qr/^[a-z]/, "error message should be capitalized";
        $code_errors{$message} = $ARGV;
    }
}

#note dump( \%code_errors );

# collect all tested error messages
my %test_errors;
@ARGV = <t/expected/*.txt>;
while (<>) {
    if (/error: (.*)/) {
        my $message = $1;
        $test_errors{$message} = $ARGV;
    }
}

#note dump( \%test_errors );

# eliminate same messages
my @code_errors_by_length =
    sort { length($b) <=> length($a) } keys %code_errors;
for my $code_message (@code_errors_by_length) {
    my $found;
    my @test_errors_by_length =
        sort { length($b) <=> length($a) } keys %test_errors;
    for my $test_message (@test_errors_by_length) {
        if (
            $code_message eq substr( $test_message, 0, length($code_message) ) )
        {
            $found = 1;
            delete $test_errors{$test_message};
        }
    }
    if ($found) {
        delete $code_errors{$code_message};
    }
}

is scalar( keys %code_errors ), 0, "all code messages in code";
is scalar( keys %test_errors ), 0, "all test messages in tests";

# show unmatched
my @unmatched;
for my $message ( keys %code_errors ) {
    push @unmatched, "$message [code]";
}
for my $message ( keys %test_errors ) {
    push @unmatched, "$message [test]";
}
@unmatched = sort @unmatched;
note dump( \@unmatched ) if @unmatched;

done_testing;
