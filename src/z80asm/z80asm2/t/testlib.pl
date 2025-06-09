#!/usr/bin/env perl

use Modern::Perl;
use Test::More;
use Config;
use Path::Tiny;

$ENV{PATH} = join($Config{path_sep}, 
			".",
			"../../../bin",
			$ENV{PATH});

use vars '$exec', '$test', '$bmk', '$null';

$exec = $^O =~ /MSWin32|msys/ ? "./z80asm.exe" : "./z80asm";
$test = "test_".(($0 =~ s/\.t$//r) =~ s/[\.\/\\]/_/gr);
$bmk = "t/".path($0)->basename(".t").".bmk";
$null = ($^O eq 'MSWin32') ? 'nul' : '/dev/null';

sub run_ok {
    my($cmd) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
	
	ok 1, "Running: $cmd";
    ok 0==system($cmd), $cmd;
	
	(Test::More->builder->is_passing) or die;
}

sub run_nok {
    my($cmd) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
	
	ok 1, "Running: $cmd";
    ok 0!=system($cmd), $cmd;
	
	(Test::More->builder->is_passing) or die;
}

sub unlink_testfiles {
	my(@additional) = @_;
    unlink(<${test}*>, @additional) 
        if !$ENV{DEBUG} && Test::More->builder->is_passing;
}

1;
