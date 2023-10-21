#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

#-------------------------------------------------------------------------------
# test IF
#-------------------------------------------------------------------------------

for my $H ("", "#") {
	
z80asm_nok("", "", <<END_ASM, <<END_ERR);
		${H}if
END_ASM
$test.asm:1: error: syntax error in expression
  ^---- ${H}if
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		${H}if 1+
END_ASM
$test.asm:1: error: syntax error in expression
  ^---- ${H}if 1+
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		${H}if 1,
END_ASM
$test.asm:1: error: syntax error
  ^---- ${H}if 1,
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		${H}if 1
END_ASM
$test.asm:2: error: unbalanced control structure started at: $test.asm:1
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		${H}else
END_ASM
$test.asm:1: error: unbalanced control structure
  ^---- ${H}else
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		${H}elif 1
END_ASM
$test.asm:1: error: unbalanced control structure
  ^---- ${H}elif 1
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		${H}endif
END_ASM
$test.asm:1: error: unbalanced control structure
  ^---- ${H}endif
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		${H}if 1
		${H}else
		${H}else
		${H}endif
END_ASM
$test.asm:3: error: unbalanced control structure started at: $test.asm:1
  ^---- ${H}else
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		${H}if 1
		${H}else
		${H}elif 2
		${H}endif
END_ASM
$test.asm:3: error: unbalanced control structure started at: $test.asm:1
  ^---- ${H}elif 2
END_ERR

spew("$test.inc", <<END_ASM);
	${H}if 1
END_ASM
z80asm_nok("", "", <<END_ASM, <<END_ERR);
		include "$test.inc"
END_ASM
$test.asm:2: error: unbalanced control structure started at: $test.inc:1
END_ERR

spew("$test.asm", <<END_ASM);
		${H}if X		
		  defb 1	
		  ${H}if Y		
			defb 2	
		  ${H}else		
			defb 3	
		  ${H}endif		
		${H}else		
		  defb 4	
		  ${H}if Y		
			defb 5	
		  ${H}else		
			defb 6	
		  ${H}endif		
		${H}endif
		${H}if X
		  defb 7
		${H}endif
		${H}if !X
		  defb 8
		${H}endif
		${H}if X|1
		  defb 9
		${H}endif
END_ASM

capture_ok("z88dk-z80asm -b $test.asm", "");
check_bin_file("$test.bin", bytes(4, 6, 8, 9));

capture_ok("z88dk-z80asm -b -DX $test.asm", "");
check_bin_file("$test.bin", bytes(1, 3, 7, 9));

capture_ok("z88dk-z80asm -b -DY $test.asm", "");
check_bin_file("$test.bin", bytes(4, 5, 8, 9));

capture_ok("z88dk-z80asm -b -DX -DY $test.asm", "");
check_bin_file("$test.bin", bytes(1, 2, 7, 9));

#-------------------------------------------------------------------------------
# test IF/ELIF
#-------------------------------------------------------------------------------

# chained IF/ELSE IF
spew("$test.asm", <<END_ASM);
		${H}if ONE
			defb 1
		${H}else
			${H}if TWO
				defb 2
			${H}else
				${H}if THREE
					defb 3
				${H}else
					defb 0
				${H}endif
			${H}endif
		${H}endif
END_ASM

capture_ok("z88dk-z80asm -b $test.asm", "");
check_bin_file("$test.bin", bytes(0));

capture_ok("z88dk-z80asm -b -DONE $test.asm", "");
check_bin_file("$test.bin", bytes(1));

capture_ok("z88dk-z80asm -b -DTWO $test.asm", "");
check_bin_file("$test.bin", bytes(2));

capture_ok("z88dk-z80asm -b -DTHREE $test.asm", "");
check_bin_file("$test.bin", bytes(3));

# IF/ELIF
spew("$test.asm", <<END_ASM);
		${H}if ONE
			defb 1
		${H}elif TWO
			defb 2
		${H}elif THREE
			defb 3
		${H}else
			defb 0
		${H}endif
END_ASM

capture_ok("z88dk-z80asm -b $test.asm", "");
check_bin_file("$test.bin", bytes(0));

capture_ok("z88dk-z80asm -b -DONE $test.asm", "");
check_bin_file("$test.bin", bytes(1));

capture_ok("z88dk-z80asm -b -DTWO $test.asm", "");
check_bin_file("$test.bin", bytes(2));

capture_ok("z88dk-z80asm -b -DTHREE $test.asm", "");
check_bin_file("$test.bin", bytes(3));

#-------------------------------------------------------------------------------
# test IFDEF/IFNDEF
#-------------------------------------------------------------------------------

for my $ifdef (qw(ifdef ifndef)) {
	ok 1, "Test $ifdef";
	
	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		${H}$ifdef
END_ASM
$test.asm:1: error: syntax error
  ^---- ${H}$ifdef
END_ERR

	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		${H}el$ifdef
END_ASM
$test.asm:1: error: unbalanced control structure
  ^---- ${H}el$ifdef
END_ERR

	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		${H}$ifdef 1
END_ASM
$test.asm:1: error: syntax error
  ^---- ${H}$ifdef 1
END_ERR

	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		${H}$ifdef hello,
END_ASM
$test.asm:1: error: syntax error
  ^---- ${H}$ifdef hello,
END_ERR

	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		${H}$ifdef hello
END_ASM
$test.asm:2: error: unbalanced control structure started at: $test.asm:1
END_ERR

	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		${H}el$ifdef hello
END_ASM
$test.asm:1: error: unbalanced control structure
  ^---- ${H}el$ifdef hello
END_ERR

	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		${H}$ifdef hello
		${H}else
		${H}else
		${H}endif
END_ASM
$test.asm:3: error: unbalanced control structure started at: $test.asm:1
  ^---- ${H}else
END_ERR

	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		${H}$ifdef hello
		${H}else
		${H}el$ifdef hello
		${H}endif
END_ASM
$test.asm:3: error: unbalanced control structure started at: $test.asm:1
  ^---- ${H}el$ifdef hello
END_ERR

	spew("$test.inc", <<END_ASM);
		${H}$ifdef hello
END_ASM
	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		${H}include "$test.inc"
END_ASM
$test.asm:2: error: unbalanced control structure started at: $test.inc:1
END_ERR

}

spew("$test.asm", <<END_ASM);
		${H}ifdef X		
		  defb 1	
		  ${H}ifdef Y		
			defb 2	
		  ${H}else		
			defb 3	
		  ${H}endif		
		${H}else		
		  defb 4	
		  ${H}ifdef Y		
			defb 5	
		  ${H}else		
			defb 6	
		  ${H}endif		
		${H}endif
		${H}ifdef X
		  defb 7
		${H}endif
		${H}ifndef X
		  defb 8
		${H}endif
END_ASM

capture_ok("z88dk-z80asm -b $test.asm", "");
check_bin_file("$test.bin", bytes(4, 6, 8));

capture_ok("z88dk-z80asm -b -DX $test.asm", "");
check_bin_file("$test.bin", bytes(1, 3, 7));

capture_ok("z88dk-z80asm -b -DY $test.asm", "");
check_bin_file("$test.bin", bytes(4, 5, 8));

capture_ok("z88dk-z80asm -b -DX -DY $test.asm", "");
check_bin_file("$test.bin", bytes(1, 2, 7));

#-------------------------------------------------------------------------------
# test IFDEF/ELIFDEF
#-------------------------------------------------------------------------------

# chained IFDEF/ELSE IFDEF
spew("$test.asm", <<END_ASM);
		${H}ifdef ONE
			defb 1
		${H}else
			${H}ifdef TWO
				defb 2
			${H}else
				${H}ifdef THREE
					defb 3
				${H}else
					defb 0
				${H}endif
			${H}endif
		${H}endif
END_ASM

capture_ok("z88dk-z80asm -b $test.asm", "");
check_bin_file("$test.bin", bytes(0));

capture_ok("z88dk-z80asm -b -DONE $test.asm", "");
check_bin_file("$test.bin", bytes(1));

capture_ok("z88dk-z80asm -b -DTWO $test.asm", "");
check_bin_file("$test.bin", bytes(2));

capture_ok("z88dk-z80asm -b -DTHREE $test.asm", "");
check_bin_file("$test.bin", bytes(3));

# IF/ELIFDEF
spew("$test.asm", <<END_ASM);
		${H}ifdef ONE
			defb 1
		${H}elifdef TWO
			defb 2
		${H}elifdef THREE
			defb 3
		${H}else
			defb 0
		${H}endif
END_ASM

capture_ok("z88dk-z80asm -b $test.asm", "");
check_bin_file("$test.bin", bytes(0));

capture_ok("z88dk-z80asm -b -DONE $test.asm", "");
check_bin_file("$test.bin", bytes(1));

capture_ok("z88dk-z80asm -b -DTWO $test.asm", "");
check_bin_file("$test.bin", bytes(2));

capture_ok("z88dk-z80asm -b -DTHREE $test.asm", "");
check_bin_file("$test.bin", bytes(3));

# chained IFNDEF/ELSE IFNDEF
spew("$test.asm", <<END_ASM);
		${H}ifndef ONE
			defb 1
		${H}else
			${H}ifndef TWO
				defb 2
			${H}else
				${H}ifndef THREE
					defb 3
				${H}else
					defb 0
				${H}endif
			${H}endif
		${H}endif
END_ASM

capture_ok("z88dk-z80asm -b -DONE -DTWO -DTHREE $test.asm", "");
check_bin_file("$test.bin", bytes(0));

capture_ok("z88dk-z80asm -b       -DTWO -DTHREE $test.asm", "");
check_bin_file("$test.bin", bytes(1));

capture_ok("z88dk-z80asm -b -DONE       -DTHREE $test.asm", "");
check_bin_file("$test.bin", bytes(2));

capture_ok("z88dk-z80asm -b -DONE -DTWO         $test.asm", "");
check_bin_file("$test.bin", bytes(3));

# IF/ELIFNDEF
spew("$test.asm", <<END_ASM);
		${H}ifndef ONE
			defb 1
		${H}elifndef TWO
			defb 2
		${H}elifndef THREE
			defb 3
		${H}else
			defb 0
		${H}endif
END_ASM

capture_ok("z88dk-z80asm -b -DONE -DTWO -DTHREE $test.asm", "");
check_bin_file("$test.bin", bytes(0));

capture_ok("z88dk-z80asm -b       -DTWO -DTHREE $test.asm", "");
check_bin_file("$test.bin", bytes(1));

capture_ok("z88dk-z80asm -b -DONE       -DTHREE $test.asm", "");
check_bin_file("$test.bin", bytes(2));

capture_ok("z88dk-z80asm -b -DONE -DTWO         $test.asm", "");
check_bin_file("$test.bin", bytes(3));

#------------------------------------------------------------------------------
# unbalanced control structure is first file, second file ok
#------------------------------------------------------------------------------

spew("$test.1.asm", <<END_ASM);
		${H}if 1
END_ASM
spew("$test.2.asm", <<END_ASM);
		nop
END_ASM
capture_nok("z88dk-z80asm -b $test.1.asm $test.2.asm", <<END_ERR);
$test.1.asm:2: error: unbalanced control structure started at: $test.1.asm:1
END_ERR

}

#-------------------------------------------------------------------------------
# test CPU-defining constants
#-------------------------------------------------------------------------------
spew("$test.asm", <<'END_ASM');
	if __CPU_INTEL__		: defm "intel "			: endif
	if __CPU_8080__			: defm "8080 "			: endif
	if __CPU_8085__			: defm "8085 "			: endif
													
	if __CPU_ZILOG__		: defm "zilog "			: endif
	if __CPU_Z80__			: defm "z80 "			: endif
	if __CPU_Z80_STRICT__	: defm "z80_strict "	: endif
	if __CPU_Z80N__			: defm "z80n " 			: endif
	if __CPU_Z180__			: defm "z180 "			: endif
	if __CPU_EZ80__			: defm "ez80 "			: endif
	if __CPU_EZ80_Z80__		: defm "ez80_z80 "		: endif
													
	if __CPU_R800__			: defm "r800 "			: endif
													
	if __CPU_GBZ80__		: defm "gbz80 "			: endif
													
	if __CPU_KC160__		: defm "kc160 " 		: endif
	if __CPU_KC160_Z80__	: defm "kc160_z80 " 	: endif
													
	if __CPU_RABBIT__		: defm "rabbit "		: endif
	if __CPU_R2KA__			: defm "r2ka "			: endif
	if __CPU_R3K__			: defm "r3k "			: endif
	if __CPU_R4K__			: defm "r4k "			: endif
	if __CPU_R5K__			: defm "r5k "			: endif
													
	if __CPU_TI83__			: defm "ti83 "  		: endif
	if __CPU_TI83PLUS__		: defm "ti83plus "  	: endif
													
	if __SWAP_IX_IY__		: defm "-IXIY "			: endif
	
	if __FLOAT_GENMATH__	: defm "float_genmath "	: endif
	if __FLOAT_MATH48__		: defm "float_math48 "  : endif
	if __FLOAT_IEEE16__		: defm "float_ieee16 "  : endif
	if __FLOAT_IEEE32__		: defm "float_ieee32 "  : endif
	if __FLOAT_IEEE64__		: defm "float_ieee64 "  : endif
	if __FLOAT_Z80__		: defm "float_z80 "  	: endif
	if __FLOAT_ZX81__		: defm "float_zx81 "  	: endif
	if __FLOAT_ZX__			: defm "float_zx "  	: endif
	if __FLOAT_Z88__		: defm "float_z88 "  	: endif
	if __FLOAT_MBFS__		: defm "float_mbfs "  	: endif
	if __FLOAT_MBF40__		: defm "float_mbf40 "  	: endif
	if __FLOAT_MBF64__		: defm "float_mbf64 "  	: endif
	if __FLOAT_AM9511__		: defm "float_am9511 "  : endif
END_ASM

my %defines = (
	8080		=> "intel 8080 ",
	8085		=> "intel 8085 ",
	z80			=> "zilog z80 ",
	z80_strict	=> "zilog z80_strict ",
	z80n		=> "zilog z80n ",
	z180		=> "zilog z180 ",
	ez80		=> "zilog ez80 ",
	ez80_z80	=> "zilog ez80_z80 ",
	r800		=> "r800 ",
	gbz80		=> "gbz80 ",
	kc160		=> "kc160 ",
	kc160_z80	=> "kc160_z80 ",
	r2ka		=> "rabbit r2ka ",
	r3k			=> "rabbit r3k ",
	r4k			=> "rabbit r4k ",
	r5k			=> "rabbit r5k ",
	ti83		=> "zilog z80_strict ti83 ",
	ti83plus	=> "zilog z80_strict ti83plus ",
);

for my $cpu (@CPUS, qw( ti83 ti83plus )) {
	for my $ixiy ("", "-IXIY ") {
		for my $math (qw( genmath math48 ieee16 ieee32 ieee64 
						  z80 zx81 zx z88 mbfs mbf40 mbf64 am9511 )) {

			if ($cpu eq 'z80' && $ixiy eq '' && $math eq 'genmath') {
				capture_ok("z88dk-z80asm -b $test.asm", "");
				check_bin_file("$test.bin", $defines{$cpu}."float_${math} ");
			}
			
			capture_ok("z88dk-z80asm -b -m$cpu $ixiy -float=$math $test.asm", "");
			check_bin_file("$test.bin", $defines{$cpu}."${ixiy}float_${math} ");		
		}
	}
}

unlink_testfiles;
done_testing;
