#!/usr/bin/env perl

# Test https://github.com/z88dk/z88dk/issues/17
# z80asm: bug with filenames interpreting escape sequences

BEGIN { use lib 't2'; require 'testlib.pl'; }

my @slashes = ($^O eq 'MSWin32') ? ('/', '\\') : ('/');
for my $slash (@slashes) {
	ok 1, "test with slash = $slash";
	
	path("$test.dir")->mkpath;
	path("$test.dir/test.inc")->spew("defb 1");
	path("$test.dir/test1.bin")->spew_raw(bytes(2));
	path("$test.asm")->spew(<<END);
		include "$test.dir${slash}test.inc"
		binary  "$test.dir${slash}test1.bin"
		defb 3
END
	run_ok("./z88dk-z80asm -b $test.asm");
	check_bin_file("$test.bin", bytes(1, 2, 3));

	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		line 1, "$test.dir${slash}test.inc"
		ld
END_ASM
$test.dir${slash}test.inc:1: error: syntax error
  ^---- ld
END_ERR

	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		c_line 1, "$test.dir${slash}test.c"
		ld
END_ASM
$test.dir${slash}test.c:1: error: syntax error
  ^---- ld
END_ERR

	path("$test.dir")->remove_tree if Test::More->builder->is_passing;
}

unlink_testfiles;
done_testing;
