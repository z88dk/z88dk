#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;
use File::Copy;

# Test https://github.com/z88dk/z88dk/issues/2831
# ucpp: Ensure comments after #line directives are on separate lines
# Expected: 

# #line 246 "t/test_t_fgetc.c"
# ; Check for value of -1

unlink_testfiles;

# Copy the test file
my $test_file = "${test}.c";
my $source_file = "t/test_t_fgetc.c";
# If running from parent directory, adjust path
$source_file = "test_t_fgetc.c" if -f "test_t_fgetc.c" && !-f $source_file;
copy($source_file, $test_file) or die "Cannot copy $source_file to $test_file: $!";

# Run ucpp on the test file (may fail on missing headers, but should still produce output)
system("z88dk-ucpp -d $test_file -o ${test}.i 2> ${test}.err");

# Check that output file was created
ok -f "${test}.i", "${test}.i created";

# Check that #line directive is followed by newline, then "; Check for value of -1"
my $content = slurp("${test}.i");
like $content, qr/#line\s+\d+\s+"[^"]+"\s*\n\s*;\s*Check for value of -1/s, 
    "#line directive followed by newline, then '; Check for value of -1'";

unlink_testfiles;
done_testing;

