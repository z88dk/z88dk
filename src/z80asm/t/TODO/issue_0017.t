#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/17
# z80asm: bug with filenames interpreting escape sequences

my @slashes = ($^O eq 'MSWin32') ? ('/', '\\') : ('/');
for my $slash (@slashes) {
	ok 1, "test with slash = $slash";
	
	path("$test.dir")->mkpath;
	spew("$test.dir/test.inc", "defb 1");
	spew("$test.dir/test1.bin", bytes(2));
	spew("$test.asm", <<END);
		include "$test.dir${slash}test.inc"
		binary  "$test.dir${slash}test1.bin"
		incbin  "$test.dir${slash}test1.bin"
		defb 3
END
	run_ok("z88dk-z80asm -b $test.asm");
	check_bin_file("$test.bin", bytes(1, 2, 2, 3));

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
