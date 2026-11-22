#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;
use File::Copy;

# Test https://github.com/z88dk/z88dk/issues/2950
# ucpp: skipped protected include loses line sync

unlink_testfiles('guarded.h');

my $test_file = "${test}.c";
my $source_file = "t/issue_2950_empty_include_line_sync.c";
$source_file = "issue_2950_empty_include_line_sync.c"
    if -f "issue_2950_empty_include_line_sync.c" && !-f $source_file;
copy($source_file, $test_file) or die "Cannot copy $source_file to $test_file: $!";

my $header_file = "t/issue_2950_guarded.h";
$header_file = "issue_2950_guarded.h"
    if -f "issue_2950_guarded.h" && !-f $header_file;
copy($header_file, "guarded.h") or die "Cannot copy $header_file to guarded.h: $!";

run_ok("z88dk-ucpp -iquote. ${test}.c > ${test}.i");

my $content = slurp("${test}.i");
like $content,
    qr/#line\s+2\s+"[^"]*${test}\.c"(\r)?\n(\r)?\n(\r)?\nint\s+test/s,
    "skipped protected include preserves the caller line numbering";

unlink_testfiles('guarded.h');
done_testing;
