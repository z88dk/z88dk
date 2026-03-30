#!/usr/bin/env perl

#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

use Modern::Perl;
use Test::More;
use Test::HexDifferences;
use Config;
use Capture::Tiny 'capture_merged';
use Path::Tiny;
use Text::Diff;

$ENV{PATH} = join($Config{path_sep}, 
			".",
			"../../../bin",
			$ENV{PATH});

use vars '$test', '$null';
$test = "test_".($0 =~ s/\W/_/gr);
$null = ($^O eq 'MSWin32') ? 'nul' : '/dev/null';

unlink_testfiles();

#------------------------------------------------------------------------------
sub tempname {
    my($suffix) = @_;
    state $counter = 0;
    return sprintf("%s_%03d%s", $test, $counter++, $suffix);
}

#------------------------------------------------------------------------------
sub check_bin_file {
    my($got_file, $exp_file) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
	my $got_bin = path($got_file)->slurp_raw;
	my $exp_bin = path($exp_file)->slurp_raw;
	note "binary diff expected ($exp_file) got ($got_file)";
	eq_or_dump_diff($exp_bin, $got_bin, "binary files are equal");
	
	(Test::More->builder->is_passing) or die;
}

#------------------------------------------------------------------------------
sub check_text_file {
    my($got_file, $exp_file) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
	(my $got_text = path($got_file)->slurp) =~ s/\r\n/\n/g;
	(my $exp_text = path($exp_file)->slurp) =~ s/\r\n/\n/g;
	
	note "text diff expected ($exp_file) got ($got_file)";
	my $diff = diff(\$exp_text, \$got_text, {STYLE => 'Unified'});
	if ($diff ne "") {
		note $diff;
		if ($ENV{DEBUG}) {
			system("start \"\" '/c/Program Files (x86)/WinMerge/WinMergeU.exe' ".
				   "$exp_file $got_file");
		}
	}
	ok $diff eq "", "text files are equal";
	
	(Test::More->builder->is_passing) or die;
}

#------------------------------------------------------------------------------
sub capture_ok {
    my($cmd, $exp_file) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
    run_ok($cmd." > ${test}.out 2>&1");
	run_ok("dos2unix ${test}.out 2> $null");
    check_text_file("${test}.out", $exp_file);
	
	(Test::More->builder->is_passing) or die;
}

#------------------------------------------------------------------------------
sub capture_nok {
    my($cmd, $exp_file) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    run_nok($cmd." 2> ${test}.err 1>&2");
	run_ok("dos2unix ${test}.err 2> $null");
    check_text_file("${test}.err", $exp_file);
	
	(Test::More->builder->is_passing) or die;
}

#------------------------------------------------------------------------------
sub run_ok {
    my($cmd) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
	
	ok 1, "Running: $cmd";
    ok 0==system($cmd), $cmd;
	
	(Test::More->builder->is_passing) or die;
}

#------------------------------------------------------------------------------
sub run_nok {
    my($cmd) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
	
	ok 1, "Running: $cmd";
    ok 0!=system($cmd), $cmd;
	
	(Test::More->builder->is_passing) or die;
}

#------------------------------------------------------------------------------
sub unlink_testfiles {
	my(@additional) = @_;
    unlink(<${test}*>, @additional) 
        if Test::More->builder->is_passing;
}

1;
