#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;
use File::Copy;

# Test https://github.com/z88dk/z88dk/issues/2831
# ucpp: Test with large file (test_t_issue_2831.c) to ensure no excessive blank lines
# are generated when processing files with many conditional compilation blocks

unlink_testfiles;

# Copy the test file
my $test_file = "${test}.c";
my $source_file = "t/test_t_issue_2831.c";
# If running from parent directory, adjust path
$source_file = "test_t_issue_2831.c" if -f "test_t_issue_2831.c" && !-f $source_file;
copy($source_file, $test_file) or die "Cannot copy $source_file to $test_file: $!";

# Run ucpp on the test file
run_ok("z88dk-ucpp -d $test_file -o ${test}.i 2> ${test}.err");

# Check that output file was created
ok -f "${test}.i", "${test}.i created";

# Check max consecutive blank lines (should be reasonable, < 10)
sub count_max_consecutive_blank_lines {
    my($file) = @_;
    my $max = 0;
    my $count = 0;
    open(my $fh, "<", $file) or die "Cannot open $file: $!";
    while (<$fh>) {
        if (/^\s*$/) {
            $count++;
            $max = $count if $count > $max;
        } else {
            $count = 0;
        }
    }
    close($fh);
    return $max;
}

my $max_blanks = count_max_consecutive_blank_lines("${test}.i");
cmp_ok($max_blanks, '<', 10, "max consecutive blank lines is reasonable ($max_blanks)");

# Check file size is reasonable (not millions of lines)
my $size = -s "${test}.i";
my $line_count = `wc -l < ${test}.i`;
chomp $line_count;

cmp_ok($size, '<', 10000, "output file size is reasonable ($size bytes)");
cmp_ok($line_count, '<', 500, "output file line count is reasonable ($line_count lines)");

unlink_testfiles;
done_testing;

