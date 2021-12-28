#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

#-------------------------------------------------------------------------------
# syntax
#-------------------------------------------------------------------------------
for my $binary ("binary", "incbin") {
	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		$binary 
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		$binary 'a'
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		$binary "$test.dat" extra
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

	path("$test.dat")->spew_raw(bytes(0, 0x0a, 0x0d, 0xff));

	z80asm_ok("", "", "", <<END, bytes(1,1,1, (0, 0x0a, 0x0d, 0xff) x 2, 3, 7));
		ld bc,101h
L1:		$binary "$test.dat" ; comment
.L2		$binary "$test.dat" ; comment
		defb L1, L2
END
}

#-------------------------------------------------------------------------------
# very small and very large binary
#-------------------------------------------------------------------------------
my $blob = join("", map{chr} 0..255) x 256;
for my $bin ("", $blob) {
	path("$test.dat")->spew_raw($bin);

	z80asm_ok("", "", "", <<END, $bin);
		binary "$test.dat"
END
}

path("$test.dat")->spew_raw($blob);			# 64k
z80asm_nok("", "", <<END_ASM, <<END_ERR);
		nop
		binary "$test.dat"
END_ASM
Error at file '$test.asm' line 2: max. code size of 65536 bytes reached
END_ERR

path("$test.dat")->spew_raw($blob."x");		# 64k+1
z80asm_nok("", "", <<END_ASM, <<END_ERR);
		binary "$test.dat"
END_ASM
Error at file '$test.asm' line 1: max. code size of 65536 bytes reached
END_ERR

#-------------------------------------------------------------------------------
# with directories
#-------------------------------------------------------------------------------
path("$test.dir")->mkpath;

path("$test.dir/test.dat")->spew_raw($blob);

# no -I, full path : OK
z80asm_ok("", "", "", <<END, $blob);
		binary "$test.dir/test.dat"
END

# no -I, only file name : error
z80asm_nok("", "", <<END_ASM, <<END_ERR);
		binary "test.dat"
END_ASM
Error at file '$test.asm' line 1: cannot read file 'test.dat'
END_ERR

# -I : OK
z80asm_ok("-b -I$test.dir", "", "", <<END, $blob);
		binary "test.dat"
END

# -I, full path : OK
z80asm_ok("-b -I$test.dir", "", "", <<END, $blob);
		binary "$test.dir/test.dat"
END

# -I using environment variables
$ENV{TEST_DIR} = "$test.dir";
z80asm_ok('-b -I${TEST_DIR}', "", "", <<END, $blob);
		binary "$test.dir/test.dat"
END
delete $ENV{TEST_DIR};

# directory of source file is added to include path
path("$test.dir/test.asm")->spew(<<END);
		binary "test.dat"
END
run_ok("./z88dk-z80asm -b $test.dir/test.asm");
check_bin_file("$test.dir/test.bin", $blob);

path("$test.dir")->remove_tree if Test::More->builder->is_passing;

unlink_testfiles;
done_testing;
