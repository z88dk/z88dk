#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

#-------------------------------------------------------------------------------
# syntax
#-------------------------------------------------------------------------------
for my $binary ("binary", "incbin") {
	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		$binary 
END_ASM
$test.asm:1: error: syntax error
  ^---- $binary
END_ERR

	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		$binary 'a'
END_ASM
$test.asm:1: error: syntax error
  ^---- $binary 'a'
END_ERR

	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		$binary "$test.dat" extra
END_ASM
$test.asm:1: error: syntax error
  ^---- $binary "$test.dat" extra
END_ERR

	spew("$test.dat", bytes(0, 0x0a, 0x0d, 0xff));

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
	spew("$test.dat", $bin);

	z80asm_ok("", "", "", <<END, $bin);
		binary "$test.dat"
END
}

spew("$test.dat", $blob);			# 64k
z80asm_nok("", "", <<END_ASM, <<END_ERR);
		nop
		binary "$test.dat"
END_ASM
$test.asm:2: error: segment overflow
  ^---- binary "test_t_BINARY.dat"
      ^---- defb 240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255
END_ERR

spew("$test.dat", $blob."x");		# 64k+1
z80asm_nok("", "", <<END_ASM, <<END_ERR);
		binary "$test.dat"
END_ASM
$test.asm:1: error: segment overflow
  ^---- binary "test_t_BINARY.dat"
      ^---- defb 120
END_ERR

#-------------------------------------------------------------------------------
# with directories
#-------------------------------------------------------------------------------
path("$test.dir")->mkpath;

spew("$test.dir/test.dat", $blob);

# no -I, full path : OK
z80asm_ok("", "", "", <<END, $blob);
		binary "$test.dir/test.dat"
END

# no -I, only file name : error
z80asm_nok("", "", <<END_ASM, <<END_ERR);
		binary "test.dat"
END_ASM
$test.asm:1: error: file not found: test.dat
  ^---- binary "test.dat"
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
spew("$test.dir/test.asm", <<END);
		binary "test.dat"
END
run_ok("z88dk-z80asm -b $test.dir/test.asm");
check_bin_file("$test.dir/test.bin", $blob);

path("$test.dir")->remove_tree if Test::More->builder->is_passing;
unlink_testfiles;
done_testing;
