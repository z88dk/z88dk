#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

#-------------------------------------------------------------------------------
# test IF
#-------------------------------------------------------------------------------

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		if
END_ASM
Error at file '$test.asm' line 1: syntax error in expression
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		if 1+
END_ASM
Error at file '$test.asm' line 1: syntax error in expression
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		if 1,
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		if 1
END_ASM
Error at file '$test.asm' line 2: unbalanced control structure started at file '$test.asm' line 1
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		else
END_ASM
Error at file '$test.asm' line 1: unbalanced control structure
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		elif 1
END_ASM
Error at file '$test.asm' line 1: unbalanced control structure
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		endif
END_ASM
Error at file '$test.asm' line 1: unbalanced control structure
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		if 1
		else
		else
		endif
END_ASM
Error at file '$test.asm' line 3: unbalanced control structure started at file '$test.asm' line 1
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		if 1
		else
		elif 2
		endif
END_ASM
Error at file '$test.asm' line 3: unbalanced control structure started at file '$test.asm' line 1
END_ERR

path("$test.inc")->spew(<<END_ASM);
	if 1
END_ASM
z80asm_nok("", "", <<END_ASM, <<END_ERR);
		include "$test.inc"
END_ASM
Error at file '$test.asm' line 2: unbalanced control structure started at file '$test.inc' line 1
END_ERR

path("$test.asm")->spew(<<END_ASM);
		if X		
		  defb 1	
		  if Y		
			defb 2	
		  else		
			defb 3	
		  endif		
		else		
		  defb 4	
		  if Y		
			defb 5	
		  else		
			defb 6	
		  endif		
		endif
		if X
		  defb 7
		endif
		if !X
		  defb 8
		endif
		if X|1
		  defb 9
		endif
END_ASM

capture_ok("./z88dk-z80asm -b $test.asm", "");
check_bin_file("$test.bin", bytes(4, 6, 8, 9));

capture_ok("./z88dk-z80asm -b -DX $test.asm", "");
check_bin_file("$test.bin", bytes(1, 3, 7, 9));

capture_ok("./z88dk-z80asm -b -DY $test.asm", "");
check_bin_file("$test.bin", bytes(4, 5, 8, 9));

capture_ok("./z88dk-z80asm -b -DX -DY $test.asm", "");
check_bin_file("$test.bin", bytes(1, 2, 7, 9));

#-------------------------------------------------------------------------------
# test IF/ELIF
#-------------------------------------------------------------------------------

# chained IF/ELSE IF
path("$test.asm")->spew(<<END_ASM);
		if ONE
			defb 1
		else
			if TWO
				defb 2
			else
				if THREE
					defb 3
				else
					defb 0
				endif
			endif
		endif
END_ASM

capture_ok("./z88dk-z80asm -b $test.asm", "");
check_bin_file("$test.bin", bytes(0));

capture_ok("./z88dk-z80asm -b -DONE $test.asm", "");
check_bin_file("$test.bin", bytes(1));

capture_ok("./z88dk-z80asm -b -DTWO $test.asm", "");
check_bin_file("$test.bin", bytes(2));

capture_ok("./z88dk-z80asm -b -DTHREE $test.asm", "");
check_bin_file("$test.bin", bytes(3));

# IF/ELIF
path("$test.asm")->spew(<<END_ASM);
		if ONE
			defb 1
		elif TWO
			defb 2
		elif THREE
			defb 3
		else
			defb 0
		endif
END_ASM

capture_ok("./z88dk-z80asm -b $test.asm", "");
check_bin_file("$test.bin", bytes(0));

capture_ok("./z88dk-z80asm -b -DONE $test.asm", "");
check_bin_file("$test.bin", bytes(1));

capture_ok("./z88dk-z80asm -b -DTWO $test.asm", "");
check_bin_file("$test.bin", bytes(2));

capture_ok("./z88dk-z80asm -b -DTHREE $test.asm", "");
check_bin_file("$test.bin", bytes(3));

#-------------------------------------------------------------------------------
# test IFDEF/IFNDEF
#-------------------------------------------------------------------------------

for my $ifdef (qw(ifdef ifndef)) {
	ok 1, "Test $ifdef";
	
	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		$ifdef
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		el$ifdef
END_ASM
Error at file '$test.asm' line 1: unbalanced control structure
END_ERR

	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		$ifdef 1
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		$ifdef hello,
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		$ifdef hello
END_ASM
Error at file '$test.asm' line 2: unbalanced control structure started at file '$test.asm' line 1
END_ERR

	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		el$ifdef hello
END_ASM
Error at file '$test.asm' line 1: unbalanced control structure
END_ERR

	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		$ifdef hello
		else
		else
		endif
END_ASM
Error at file '$test.asm' line 3: unbalanced control structure started at file '$test.asm' line 1
END_ERR

	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		$ifdef hello
		else
		el$ifdef hello
		endif
END_ASM
Error at file '$test.asm' line 3: unbalanced control structure started at file '$test.asm' line 1
END_ERR

	path("$test.inc")->spew(<<END_ASM);
		$ifdef hello
END_ASM
	z80asm_nok("", "", <<END_ASM, <<END_ERR);
		include "$test.inc"
END_ASM
Error at file '$test.asm' line 2: unbalanced control structure started at file '$test.inc' line 1
END_ERR

}

path("$test.asm")->spew(<<END_ASM);
		ifdef X		
		  defb 1	
		  ifdef Y		
			defb 2	
		  else		
			defb 3	
		  endif		
		else		
		  defb 4	
		  ifdef Y		
			defb 5	
		  else		
			defb 6	
		  endif		
		endif
		ifdef X
		  defb 7
		endif
		ifndef X
		  defb 8
		endif
END_ASM

capture_ok("./z88dk-z80asm -b $test.asm", "");
check_bin_file("$test.bin", bytes(4, 6, 8));

capture_ok("./z88dk-z80asm -b -DX $test.asm", "");
check_bin_file("$test.bin", bytes(1, 3, 7));

capture_ok("./z88dk-z80asm -b -DY $test.asm", "");
check_bin_file("$test.bin", bytes(4, 5, 8));

capture_ok("./z88dk-z80asm -b -DX -DY $test.asm", "");
check_bin_file("$test.bin", bytes(1, 2, 7));

#-------------------------------------------------------------------------------
# test IFDEF/ELIFDEF
#-------------------------------------------------------------------------------

# chained IFDEF/ELSE IFDEF
path("$test.asm")->spew(<<END_ASM);
		ifdef ONE
			defb 1
		else
			ifdef TWO
				defb 2
			else
				ifdef THREE
					defb 3
				else
					defb 0
				endif
			endif
		endif
END_ASM

capture_ok("./z88dk-z80asm -b $test.asm", "");
check_bin_file("$test.bin", bytes(0));

capture_ok("./z88dk-z80asm -b -DONE $test.asm", "");
check_bin_file("$test.bin", bytes(1));

capture_ok("./z88dk-z80asm -b -DTWO $test.asm", "");
check_bin_file("$test.bin", bytes(2));

capture_ok("./z88dk-z80asm -b -DTHREE $test.asm", "");
check_bin_file("$test.bin", bytes(3));

# IF/ELIFDEF
path("$test.asm")->spew(<<END_ASM);
		ifdef ONE
			defb 1
		elifdef TWO
			defb 2
		elifdef THREE
			defb 3
		else
			defb 0
		endif
END_ASM

capture_ok("./z88dk-z80asm -b $test.asm", "");
check_bin_file("$test.bin", bytes(0));

capture_ok("./z88dk-z80asm -b -DONE $test.asm", "");
check_bin_file("$test.bin", bytes(1));

capture_ok("./z88dk-z80asm -b -DTWO $test.asm", "");
check_bin_file("$test.bin", bytes(2));

capture_ok("./z88dk-z80asm -b -DTHREE $test.asm", "");
check_bin_file("$test.bin", bytes(3));

# chained IFNDEF/ELSE IFNDEF
path("$test.asm")->spew(<<END_ASM);
		ifndef ONE
			defb 1
		else
			ifndef TWO
				defb 2
			else
				ifndef THREE
					defb 3
				else
					defb 0
				endif
			endif
		endif
END_ASM

capture_ok("./z88dk-z80asm -b -DONE -DTWO -DTHREE $test.asm", "");
check_bin_file("$test.bin", bytes(0));

capture_ok("./z88dk-z80asm -b       -DTWO -DTHREE $test.asm", "");
check_bin_file("$test.bin", bytes(1));

capture_ok("./z88dk-z80asm -b -DONE       -DTHREE $test.asm", "");
check_bin_file("$test.bin", bytes(2));

capture_ok("./z88dk-z80asm -b -DONE -DTWO         $test.asm", "");
check_bin_file("$test.bin", bytes(3));

# IF/ELIFNDEF
path("$test.asm")->spew(<<END_ASM);
		ifndef ONE
			defb 1
		elifndef TWO
			defb 2
		elifndef THREE
			defb 3
		else
			defb 0
		endif
END_ASM

capture_ok("./z88dk-z80asm -b -DONE -DTWO -DTHREE $test.asm", "");
check_bin_file("$test.bin", bytes(0));

capture_ok("./z88dk-z80asm -b       -DTWO -DTHREE $test.asm", "");
check_bin_file("$test.bin", bytes(1));

capture_ok("./z88dk-z80asm -b -DONE       -DTHREE $test.asm", "");
check_bin_file("$test.bin", bytes(2));

capture_ok("./z88dk-z80asm -b -DONE -DTWO         $test.asm", "");
check_bin_file("$test.bin", bytes(3));

#------------------------------------------------------------------------------
# unbalanced control structure is first file, second file ok
#------------------------------------------------------------------------------

path("$test.1.asm")->spew(<<END_ASM);
		if 1
END_ASM
path("$test.2.asm")->spew(<<END_ASM);
		nop
END_ASM
capture_nok("./z88dk-z80asm -b $test.1.asm $test.2.asm", <<END_ERR);
Error at file '$test.1.asm' line 2: unbalanced control structure started at file '$test.1.asm' line 1
END_ERR

#-------------------------------------------------------------------------------
# test CPU-defining constants
#-------------------------------------------------------------------------------

path("$test.asm")->spew(<<'END_ASM');
		if __CPU_Z80__				\ defb  1 \ endif
		if __CPU_Z80N__				\ defb  2 \ endif
		if __CPU_Z180__				\ defb  3 \ endif
		if __CPU_R2KA__				\ defb  4 \ endif
		if __CPU_R3K__				\ defb  5 \ endif
		if __CPU_8080__				\ defb  6 \ endif
		if __CPU_8085__				\ defb  7 \ endif
		if __CPU_GBZ80__			\ defb  8 \ endif
		if __CPU_ZILOG__			\ defb  9 \ endif
		if __CPU_RABBIT__			\ defb 10 \ endif
		if __CPU_INTEL__			\ defb 11 \ endif
		if __SWAP_IX_IY__			\ defb 12 \ endif
;		if __FLOAT_Z80__			\ defb 21 \ endif
;		if __FLOAT_IEEE__			\ defb 22 \ endif
;		if __FLOAT_MBFS__			\ defb 23 \ endif
;		if __FLOAT_MBF40__			\ defb 24 \ endif
;		if __FLOAT_MBF64__			\ defb 25 \ endif
;		if __FLOAT_Z88__			\ defb 26 \ endif
;		if __FLOAT_IEEE16__			\ defb 27 \ endif
;		if __FLOAT_AM9511__			\ defb 28 \ endif
		if __FLOAT_MATH48__			\ defb 29 \ endif
		if __FLOAT_GENMATH__		\ defb 30 \ endif
;		if __FLOAT_ZX__				\ defb 31 \ endif
;		if __FLOAT_ZX81__			\ defb 32 \ endif
END_ASM

capture_ok("./z88dk-z80asm -b $test.asm", "");
check_bin_file("$test.bin", bytes(1, 9, 30));

capture_ok("./z88dk-z80asm -b -IXIY $test.asm", "");
check_bin_file("$test.bin", bytes(1, 9, 12, 30));

capture_ok("./z88dk-z80asm -b -mz80 $test.asm", "");
check_bin_file("$test.bin", bytes(1, 9, 30));

capture_ok("./z88dk-z80asm -b -mz80 -IXIY $test.asm", "");
check_bin_file("$test.bin", bytes(1, 9, 12, 30));

capture_ok("./z88dk-z80asm -b -mz80n $test.asm", "");
check_bin_file("$test.bin", bytes(2, 9, 30));

capture_ok("./z88dk-z80asm -b -mz80n -IXIY $test.asm", "");
check_bin_file("$test.bin", bytes(2, 9, 12, 30));

capture_ok("./z88dk-z80asm -b -mz180 $test.asm", "");
check_bin_file("$test.bin", bytes(3, 9, 30));

capture_ok("./z88dk-z80asm -b -mz180 -IXIY $test.asm", "");
check_bin_file("$test.bin", bytes(3, 9, 12, 30));

capture_ok("./z88dk-z80asm -b -mr2ka $test.asm", "");
check_bin_file("$test.bin", bytes(4, 10, 30));

capture_ok("./z88dk-z80asm -b -mr2ka -IXIY $test.asm", "");
check_bin_file("$test.bin", bytes(4, 10, 12, 30));

capture_ok("./z88dk-z80asm -b -mr3k $test.asm", "");
check_bin_file("$test.bin", bytes(5, 10, 30));

capture_ok("./z88dk-z80asm -b -mr3k -IXIY $test.asm", "");
check_bin_file("$test.bin", bytes(5, 10, 12, 30));

capture_ok("./z88dk-z80asm -b -m8080 $test.asm", "");
check_bin_file("$test.bin", bytes(6, 11, 30));

capture_ok("./z88dk-z80asm -b -m8080 -IXIY $test.asm", "");
check_bin_file("$test.bin", bytes(6, 11, 12, 30));

capture_ok("./z88dk-z80asm -b -m8085 $test.asm", "");
check_bin_file("$test.bin", bytes(7, 11, 30));

capture_ok("./z88dk-z80asm -b -m8085 -IXIY $test.asm", "");
check_bin_file("$test.bin", bytes(7, 11, 12, 30));

capture_ok("./z88dk-z80asm -b -mgbz80 $test.asm", "");
check_bin_file("$test.bin", bytes(8, 30));

capture_ok("./z88dk-z80asm -b -mgbz80 -IXIY $test.asm", "");
check_bin_file("$test.bin", bytes(8, 12, 30));

# capture_ok("./z88dk-z80asm -b -float=z80 $test.asm", "");
# check_bin_file("$test.bin", bytes(1, 9, 21));
# 
# capture_ok("./z88dk-z80asm -b -float=ieee $test.asm", "");
# check_bin_file("$test.bin", bytes(1, 9, 22));
# 
# capture_ok("./z88dk-z80asm -b -float=mbfs $test.asm", "");
# check_bin_file("$test.bin", bytes(1, 9, 23));
# 
# capture_ok("./z88dk-z80asm -b -float=mbf40 $test.asm", "");
# check_bin_file("$test.bin", bytes(1, 9, 24));
# 
# capture_ok("./z88dk-z80asm -b -float=mbf64 $test.asm", "");
# check_bin_file("$test.bin", bytes(1, 9, 25));
# 
# capture_ok("./z88dk-z80asm -b -float=z88 $test.asm", "");
# check_bin_file("$test.bin", bytes(1, 9, 26));
# 
# capture_ok("./z88dk-z80asm -b -float=ieee16 $test.asm", "");
# check_bin_file("$test.bin", bytes(1, 9, 27));
# 
# capture_ok("./z88dk-z80asm -b -float=am9511 $test.asm", "");
# check_bin_file("$test.bin", bytes(1, 9, 28));
# 
capture_ok("./z88dk-z80asm -b -float=math48 $test.asm", "");
check_bin_file("$test.bin", bytes(1, 9, 29));

capture_ok("./z88dk-z80asm -b -float=genmath $test.asm", "");
check_bin_file("$test.bin", bytes(1, 9, 30));

# capture_ok("./z88dk-z80asm -b -float=zx $test.asm", "");
# check_bin_file("$test.bin", bytes(1, 9, 31));
# 
# capture_ok("./z88dk-z80asm -b -float=zx81 $test.asm", "");
# check_bin_file("$test.bin", bytes(1, 9, 32));

unlink_testfiles;
done_testing;
