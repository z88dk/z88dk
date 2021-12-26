#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

#-------------------------------------------------------------------------------
# syntax
#-------------------------------------------------------------------------------
z80asm_nok("", "", <<END_ASM, <<END_ERR);
		include 
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		include 'a'
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		include "$test.inc" extra
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

path("$test.inc")->spew(<<END);
		ld a, 10
END

z80asm_ok("", "", "", <<END, bytes(0x3e, 10, 0x3e, 10, 0x3e, 10, 0, 2));
L1:		include "$test.inc" ; comment
.L2		include "$test.inc" ; comment
#		include "$test.inc" ; comment
		defb L1, L2
END

#-------------------------------------------------------------------------------
# no directories, multiple levels
#-------------------------------------------------------------------------------
path("$test.0.inc")->spew(<<END);
		ld a, 10
END
for my $n (1..9) { 
	my $n1 = $n-1;
	path("$test.$n.inc")->spew(<<END);
l$n1:	include "$test.$n1.inc"
		defb	$n
END
}
z80asm_ok("", "", "", <<END, bytes(0x3e, 10, 1..9, 0));
		include "$test.9.inc"
		nop
END

#-------------------------------------------------------------------------------
# with directories
#-------------------------------------------------------------------------------
path("$test.dir")->mkpath;

path("$test.dir/test.inc")->spew(<<END);
		ld a, 10
END

# no -I, full path : OK
z80asm_ok("", "", "", <<END, bytes(0x3e, 10));
		include "$test.dir/test.inc"
END

# no -I, only file name : error
z80asm_nok("", "", <<END_ASM, <<END_ERR);
		include "test.inc"
END_ASM
Error at file '$test.asm' line 1: cannot read file 'test.inc'
END_ERR

# -I : OK
z80asm_ok("-b -I$test.dir", "", "", <<END, bytes(0x3e, 10));
		include "test.inc"
END

# -I, full path : OK
z80asm_ok("-b -I$test.dir", "", "", <<END, bytes(0x3e, 10));
		include "$test.dir/test.inc"
END

# -I using environment variables
$ENV{TEST_DIR} = "$test.dir";
z80asm_ok('-b -I${TEST_DIR}', "", "", <<END, bytes(0x3e, 10));
		include "$test.dir/test.inc"
END
delete $ENV{TEST_DIR};

path("$test.dir")->remove_tree if Test::More->builder->is_passing;

#-------------------------------------------------------------------------------
# directory of source file is added to include path
#-------------------------------------------------------------------------------
path("$test.dir")->mkpath;

path("$test.dir/test.inc")->spew(<<END);
		ld a, 10
END
path("$test.dir/test.asm")->spew(<<END);
		include "test.inc"
END
run_ok("./z88dk-z80asm -b $test.dir/test.asm");
check_bin_file("$test.dir/test.bin", bytes(0x3e, 10));

path("$test.dir")->remove_tree if Test::More->builder->is_passing;

#-------------------------------------------------------------------------------
# BUG_0034 : If assembly process fails with fatal error, invalid library is kept
#-------------------------------------------------------------------------------
unlink "$test.inc";
z80asm_nok("-x$test.lib", "", <<END_ASM, <<END_ERR);
		include "$test.inc"
END_ASM
Error at file '$test.asm' line 1: cannot read file '$test.inc'
END_ERR
ok ! -f "$test.lib", "$test.lib does not exist";

#-------------------------------------------------------------------------------
# include recursion
#-------------------------------------------------------------------------------
path("$test.inc")->spew(<<END);
		include "$test.asm"
END
z80asm_nok("", "", <<END_ASM, <<END_ERR);
		include "$test.inc"
END_ASM
Error at file '$test.inc' line 1: cannot include file '$test.asm' recursively
END_ERR

unlink_testfiles;
done_testing;
