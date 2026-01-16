#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;
use File::Copy;

unlink_testfiles;

# Copy the test file
my $test_file = "${test}.c";
my $source_file = "t/Issue_2858_world.c";
# If running from parent directory, adjust path
$source_file = "t/Issue_2858_world.c" if -f "t/Issue_2858_world.c" && !-f $source_file;
copy($source_file, $test_file) or die "Cannot copy $source_file to $test_file: $!";

# Run ucpp on the test file (may fail on missing headers, but should still produce output)
system("z88dk-ucpp -I../../include -I../../../include -d $test_file -o ${test}.i 2> ${test}.err");

# Check that output file was created
ok -f "${test}.i", "${test}.i created";

# Check that #line directive is followed by newline, then "; Check for value of -1"
my $content = slurp("${test}.i");
like $content, qr/#line\s8\s"[^"]*"(\r)?\nint main/s, 
    "#line [file]:8 directive followed by newline, then 'main";

unlink_testfiles;
done_testing;

