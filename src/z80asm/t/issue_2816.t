#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# export symbols defined by #define

# new feature as requested
path("$test.1.asm")->spew(<<END);
	PUBLIC A1, A2, A3, A4
DEFC A1 = 0+1
A2 EQU 1+1
A3 = 2+1
#define A4 3+1
END

path("$test.asm")->spew(<<END);
	EXTERN A1, A2, A3, A4
	DEFB A1, A2, A3, A4
END

capture_ok("z88dk-z80asm -b $test.asm $test.1.asm", "");
check_bin_file("$test.bin", bytes(1, 2, 3, 4));

# check that #define still works

# define a string
z80asm_ok("", "", "", <<END, "hello");
	#define HELLO "hello"
	defb HELLO
END

z80asm_ok("", "", "", <<END, bytes(5));
	#define SUM(a,b) a+b
	defb SUM(2,3)
END

# defines expression with extern symbol
path("$test.1.asm")->spew(<<END);
	PUBLIC A1
DEFC A1 = 42
END

path("$test.asm")->spew(<<END);
	EXTERN A1
	#define A2 A1+1
	DEFB A2
END

capture_ok("z88dk-z80asm -b $test.asm $test.1.asm", "");
check_bin_file("$test.bin", bytes(43));

# define with ASMPC
z80asm_ok("-b -r100", "", "", <<END, bytes(101));
	#define XX ASMPC+1
	defb XX
END

# define with undefined symbol
path("$test.asm")->spew(<<END);
	#define A2 A1+1
	DEFB A2
END

capture_nok("z88dk-z80asm -b $test.asm", <<END);
$test.asm:2: error: undefined symbol: A1
  ^---- A1+1
END

# IFs with defined constants
z80asm_ok("", "", "", <<END, bytes(1));
	IF A1
		NOT_OUTPUT
	ELSE
		DEFB 1
	ENDIF
END

z80asm_ok("", "", "", <<END, bytes(1));
	#define A1 0
	IF A1
		NOT_OUTPUT
	ELSE
		DEFB 1
	ENDIF
END

z80asm_ok("", "", "", <<END, bytes(1));
	#define A1 1
	IF A1
		DEFB 1
	ELSE
		NOT_OUTPUT
	ENDIF
END

z80asm_ok("", "", "", <<END, bytes(1));
	A1 EQU 0
	IF A1
		NOT_OUTPUT
	ELSE
		DEFB 1
	ENDIF
END

z80asm_ok("", "", "", <<END, bytes(1));
	A1 EQU 1
	IF A1
		DEFB 1
	ELSE
		NOT_OUTPUT
	ENDIF
END

unlink_testfiles;
done_testing;
