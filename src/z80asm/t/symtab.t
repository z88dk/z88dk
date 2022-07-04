#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

#------------------------------------------------------------------------------
# -DVAR
#------------------------------------------------------------------------------

unlink_testfiles;
z80asm_nok("-b -DVAR", "", <<ASM, <<ERR);
	define VAR
ASM
${test}.asm:1: error: duplicate definition: VAR
  ^---- define VAR
ERR


unlink_testfiles;
z80asm_ok("-b -DVAR", "", "", <<ASM, bytes(1));
	defb VAR
ASM


unlink_testfiles;
z80asm_nok("-b -DVAR", "", <<ASM, <<ERR);
	defc VAR=2
ASM
${test}.asm:1: error: duplicate definition: VAR
  ^---- defc VAR=2
ERR


unlink_testfiles;
z80asm_nok("-b -DVAR", "", <<ASM, <<ERR);
	VAR: nop
ASM
${test}.asm:1: error: duplicate definition: VAR
  ^---- VAR: nop
ERR


unlink_testfiles;
z80asm_ok("-b -DVAR", "", "", <<ASM, bytes(1));
	PUBLIC VAR
	defb VAR
ASM


unlink_testfiles;
z80asm_nok("-b -DVAR", "", <<ASM, <<ERR);
	EXTERN VAR
ASM
${test}.asm:1: error: symbol redeclaration: VAR
  ^---- EXTERN VAR
ERR


#------------------------------------------------------------------------------
# define VAR
#------------------------------------------------------------------------------

unlink_testfiles;
z80asm_ok("", "", "", <<ASM, bytes(1));
	define VAR
	defb VAR
ASM


unlink_testfiles;
z80asm_nok("", "", <<ASM, <<ERR);
	undefine VAR
	defb VAR
ASM
${test}.asm:2: error: undefined symbol: VAR
  ^---- VAR
ERR


unlink_testfiles;
z80asm_ok("", "", "", <<ASM, bytes(1));
	define VAR
	undefine VAR
	define VAR
	defb VAR
ASM


unlink_testfiles;
z80asm_nok("", "", <<ASM, <<ERR);
	define VAR
	defc VAR=2
ASM
${test}.asm:2: error: duplicate definition: VAR
  ^---- defc VAR=2
ERR


unlink_testfiles;
z80asm_nok("", "", <<ASM, <<ERR);
	define VAR
	VAR: nop
ASM
${test}.asm:2: error: duplicate definition: VAR
  ^---- VAR: nop
ERR


unlink_testfiles;
z80asm_ok("", "", "", <<ASM, bytes(1));
	define VAR
	PUBLIC VAR
	defb VAR
ASM


unlink_testfiles;
z80asm_nok("", "", <<ASM, <<ERR);
	define VAR
	EXTERN VAR
ASM
${test}.asm:2: error: symbol redeclaration: VAR
  ^---- EXTERN VAR
ERR


#------------------------------------------------------------------------------
# defc VAR
#------------------------------------------------------------------------------

unlink_testfiles;
z80asm_ok("", "", "", <<ASM, bytes(1));
	defc VAR=1
	defb VAR
ASM


unlink_testfiles;
z80asm_nok("", "", <<ASM, <<ERR);
	defc VAR=1
	define VAR
ASM
${test}.asm:2: error: duplicate definition: VAR
  ^---- define VAR
ERR


unlink_testfiles;
z80asm_nok("", "", <<ASM, <<ERR);
	defc VAR=1
	defc VAR=1
ASM
${test}.asm:2: error: duplicate definition: VAR
  ^---- defc VAR=1
ERR


unlink_testfiles;
z80asm_nok("", "", <<ASM, <<ERR);
	defc VAR=1
	VAR: nop
ASM
${test}.asm:2: error: duplicate definition: VAR
  ^---- VAR: nop
ERR


unlink_testfiles;
z80asm_ok("", "", "", <<ASM, bytes(1));
	defc VAR=1
	PUBLIC VAR
	defb VAR
ASM


unlink_testfiles;
z80asm_nok("", "", <<ASM, <<ERR);
	defc VAR=1
	EXTERN VAR
ASM
${test}.asm:2: error: symbol redeclaration: VAR
  ^---- EXTERN VAR
ERR


unlink_testfiles;
spew("${test}.asm", <<END);
	PUBLIC am48_dcmp
	EXTERN mm48_cmp
	defc am48_dcmp = mm48_cmp
END
spew("${test}1.asm", <<END);
	PUBLIC mm48_cmp
	mm48_cmp: ret
END
capture_ok("z88dk-z80asm -b ${test}.asm ${test}1.asm", "");
check_bin_file("${test}.bin", bytes(0xC9));


#------------------------------------------------------------------------------
# VAR:
#------------------------------------------------------------------------------

unlink_testfiles;
z80asm_ok("", "", "", <<ASM, bytes(0));
	VAR:
	defb VAR
ASM


unlink_testfiles;
z80asm_ok("", "", "", <<ASM, bytes(1));
	defb VAR
	VAR:
ASM


unlink_testfiles;
z80asm_nok("", "", <<ASM, <<ERR);
	VAR:
	define VAR
ASM
${test}.asm:2: error: duplicate definition: VAR
  ^---- define VAR
ERR


unlink_testfiles;
z80asm_nok("", "", <<ASM, <<ERR);
	VAR:
	defc VAR=1
ASM
${test}.asm:2: error: duplicate definition: VAR
  ^---- defc VAR=1
ERR


unlink_testfiles;
z80asm_nok("", "", <<ASM, <<ERR);
	VAR:
	VAR: nop
ASM
${test}.asm:2: error: duplicate definition: VAR
  ^---- VAR: nop
ERR


unlink_testfiles;
z80asm_ok("", "", "", <<ASM, bytes(0));
	VAR:
	PUBLIC VAR
	defb VAR
ASM


unlink_testfiles;
z80asm_ok("", "", "", <<ASM, bytes(0));
	PUBLIC VAR
	VAR:
	defb VAR
ASM


unlink_testfiles;
z80asm_nok("", "", <<ASM, <<ERR);
	VAR:
	EXTERN VAR
ASM
${test}.asm:2: error: symbol redeclaration: VAR
  ^---- EXTERN VAR
ERR


#------------------------------------------------------------------------------
# PUBLIC
#------------------------------------------------------------------------------

unlink_testfiles;
spew("${test}.asm", <<END);
	PUBLIC VAR
	PUBLIC VAR
	DEFC VAR = 3
	defb VAR
END
spew("${test}1.asm", <<END);
	EXTERN VAR
	defb VAR
END
capture_ok("z88dk-z80asm -b ${test}.asm ${test}1.asm", "");
check_bin_file("${test}.bin", bytes(3, 3));


unlink_testfiles;
spew("${test}.asm", <<END);
	PUBLIC VAR
	EXTERN VAR
	DEFC VAR = 3
	defb VAR
END
spew("${test}1.asm", <<END);
	EXTERN VAR
	defb VAR
END
capture_ok("z88dk-z80asm -b ${test}.asm ${test}1.asm", "");
check_bin_file("${test}.bin", bytes(3, 3));


unlink_testfiles;
spew("${test}.asm", <<END);
	PUBLIC VAR
	GLOBAL VAR
	DEFC VAR = 3
	defb VAR
END
spew("${test}1.asm", <<END);
	EXTERN VAR
	defb VAR
END
capture_ok("z88dk-z80asm -b ${test}.asm ${test}1.asm", "");
check_bin_file("${test}.bin", bytes(3, 3));


#------------------------------------------------------------------------------
# EXTERN
#------------------------------------------------------------------------------

unlink_testfiles;
spew("${test}.asm", <<END);
	EXTERN VAR
	PUBLIC VAR
	DEFC VAR = 3
	defb VAR
END
spew("${test}1.asm", <<END);
	EXTERN VAR
	defb VAR
END
capture_ok("z88dk-z80asm -b ${test}.asm ${test}1.asm", "");
check_bin_file("${test}.bin", bytes(3, 3));


# local hides global
unlink_testfiles;
z80asm_ok("", "", "", <<ASM, bytes(0));
	EXTERN VAR
	EXTERN VAR
	VAR: defb VAR
ASM


unlink_testfiles;
spew("${test}.asm", <<END);
	EXTERN VAR
	GLOBAL VAR
	DEFC VAR = 3
	defb VAR
END
spew("${test}1.asm", <<END);
	EXTERN VAR
	defb VAR
END
capture_ok("z88dk-z80asm -b ${test}.asm ${test}1.asm", "");
check_bin_file("${test}.bin", bytes(3, 3));


#------------------------------------------------------------------------------
# GLOBAL
#------------------------------------------------------------------------------

unlink_testfiles;
spew("${test}.asm", <<END);
	GLOBAL VAR
	PUBLIC VAR
	DEFC VAR = 3
	defb VAR
END
spew("${test}1.asm", <<END);
	EXTERN VAR
	defb VAR
END
capture_ok("z88dk-z80asm -b ${test}.asm ${test}1.asm", "");
check_bin_file("${test}.bin", bytes(3, 3));


unlink_testfiles;
spew("${test}.asm", <<END);
	GLOBAL VAR
	EXTERN VAR
	DEFC VAR = 3
	defb VAR
END
spew("${test}1.asm", <<END);
	EXTERN VAR
	defb VAR
END
capture_ok("z88dk-z80asm -b ${test}.asm ${test}1.asm", "");
check_bin_file("${test}.bin", bytes(3, 3));


unlink_testfiles;
spew("${test}.asm", <<END);
	GLOBAL VAR
	GLOBAL VAR
	DEFC VAR = 3
	defb VAR
END
spew("${test}1.asm", <<END);
	EXTERN VAR
	defb VAR
END
capture_ok("z88dk-z80asm -b ${test}.asm ${test}1.asm", "");
check_bin_file("${test}.bin", bytes(3, 3));


#------------------------------------------------------------------------------
# Symbol redefined
#------------------------------------------------------------------------------

unlink_testfiles;
spew("${test}.asm", <<END);
	PUBLIC VAR
	defc VAR=3
	defb VAR
END
spew("${test}1.asm", <<END);
	PUBLIC VAR
	defc VAR=3
	defb VAR
END
capture_nok("z88dk-z80asm -b ${test}.asm ${test}1.asm", <<END);
${test}1.asm: error: duplicate definition: ${test}::VAR
END


#------------------------------------------------------------------------------
# Symbol declared global in another module
#------------------------------------------------------------------------------

unlink_testfiles;
spew("${test}.asm", <<END);
	PUBLIC VAR
	defc VAR=2
END
spew("${test}1.asm", <<END);
	PUBLIC VAR
	defc VAR=3
END
capture_nok("z88dk-z80asm -b ${test}.asm ${test}1.asm", <<END);
${test}1.asm: error: duplicate definition: ${test}::VAR
END


#------------------------------------------------------------------------------
# Case-sensitive symbols
#------------------------------------------------------------------------------

unlink_testfiles;
spew("${test}.asm", <<END);
	Defc Loc = 1
	DEFC LOC = 2
	Public Loc, LOC
	ld a, Loc
	ld a, LOC
END
spew("${test}1.asm", <<END);
	EXTERN Loc, LOC
	ld a, Loc
	ld a, LOC
END
capture_ok("z88dk-z80asm -b ${test}.asm ${test}1.asm", "");
check_bin_file("${test}.bin", bytes(0x3E,0x01,0x3E,0x02,0x3E,0x01,0x3E,0x02));


unlink_testfiles;
done_testing;

