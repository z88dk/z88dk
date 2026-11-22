#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2731
# ucpp: Excessive blank lines generated when there are large line number gaps
# from conditional compilation or #include files

unlink_testfiles;

# Create a test file with conditional compilation that causes large gaps
spew("${test}.c", <<END);
int main( void ) {

#if TEST
/*
    *
    * here comes a long comment
    *
    */
#endif

    int test = TEST;
    int a = 12 /*  <--- this is an error in line 12 */
    char b = 13;

/*
    *
    * here comes another long comment - but if'ed out
    *
    */

    int x = 21 /* <--- this is an eror in line 21 */
    char y = 22;
    return 23;
}
END

# Run ucpp with TEST=0
run_ok("z88dk-ucpp -DTEST=0 ${test}.c -o ${test}-a.i 2> ${test}-a.err");

# Run ucpp with TEST=1
run_ok("z88dk-ucpp -DTEST=1 ${test}.c -o ${test}-b.i 2> ${test}-b.err");

# Check that output files were created
ok -f "${test}-a.i", "${test}-a.i created";
ok -f "${test}-b.i", "${test}-b.i created";

# Find line numbers for "int a" and "int x"
sub find_line_number {
    my($file, $pattern) = @_;
    open(my $fh, "<", $file) or die "Cannot open $file: $!";
    my $line_num = 0;
    while (<$fh>) {
        $line_num++;
        if (/$pattern/) {
            close($fh);
            return $line_num;
        }
    }
    close($fh);
    return undef;
}

# Check "int a" is at the same line in both outputs (consistency check)
my $line_a_a = find_line_number("${test}-a.i", qr/^\s*int\s+a\s*=/);
my $line_a_b = find_line_number("${test}-b.i", qr/^\s*int\s+a\s*=/);

ok defined($line_a_a), "found 'int a' in ${test}-a.i";
ok defined($line_a_b), "found 'int a' in ${test}-b.i";
is $line_a_a, $line_a_b, "'int a' at same line in both outputs (line $line_a_a)";

# Check "int x" is at the same line in both outputs (consistency check)
my $line_x_a = find_line_number("${test}-a.i", qr/^\s*int\s+x\s*=/);
my $line_x_b = find_line_number("${test}-b.i", qr/^\s*int\s+x\s*=/);

ok defined($line_x_a), "found 'int x' in ${test}-a.i";
ok defined($line_x_b), "found 'int x' in ${test}-b.i";
is $line_x_a, $line_x_b, "'int x' at same line in both outputs (line $line_x_a)";

unlink_testfiles;
done_testing;

