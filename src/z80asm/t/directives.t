#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Test assembly directives

use Modern::Perl;
use File::Slurp;
use File::Path qw( make_path remove_tree );
BEGIN { 
	use lib '.'; 
	use t::TestZ80asm;
};

#------------------------------------------------------------------------------
# DEFGROUP - simple use tested in opcodes.t
# test error messages here
#------------------------------------------------------------------------------
z80asm(
	asm 	=> <<END,
	defgroup {
		dg1 = 65535
		dg2	= 65536					;; error: integer '65536' out of range
		dg3 = -32768
		dg4 = -32769				;; error: integer '-32769' out of range
		dg5 = undefined				;; error: symbol 'undefined' not defined
	}
END
);

z80asm(
	asm 	=> <<END,
	defgroup 
END
	error	=> "Error at file 'test.asm' line 2: missing {} block",
);

z80asm(
	asm 	=> <<END,
	defgroup {
END
	error	=> "Error at file 'test.asm' line 2: {} block not closed",
);

# BUG_0032 : DEFGROUP ignores name after assignment
z80asm(
	asm 	=> <<END,
		defgroup
		{
			f10 = 10, f11
		}
		defb f10, f11		;; 0A 0B
END
);

#------------------------------------------------------------------------------
# DEFINE / UNDEFINE
#------------------------------------------------------------------------------
z80asm(asm => "DEFINE 			;; error: syntax error");
z80asm(asm => "DEFINE aa, 		;; error: syntax error");
z80asm(asm => "UNDEFINE 		;; error: syntax error");
z80asm(asm => "UNDEFINE aa, 	;; error: syntax error");

z80asm(asm => "DEFINE aa    \n DEFB aa 		;; 01 ");
z80asm(asm => "DEFINE aa,bb \n DEFB aa,bb 	;; 01 01 ");
z80asm(asm => "DEFINE aa,bb \n UNDEFINE aa 		\n DEFB bb 	;; 01 ");
z80asm(asm => "DEFINE aa,bb \n UNDEFINE aa 		\n DEFB aa 	;; error: symbol 'aa' not defined");
z80asm(asm => "DEFINE aa,bb \n UNDEFINE aa,bb 	\n DEFB aa 	;; error: symbol 'aa' not defined");
z80asm(asm => "DEFINE aa,bb \n UNDEFINE aa,bb 	\n DEFB bb 	;; error: symbol 'bb' not defined");

#------------------------------------------------------------------------------
# DEFC
#------------------------------------------------------------------------------
z80asm(asm => "DEFC 			;; error: syntax error");
z80asm(asm => "DEFC aa			;; error: syntax error");
z80asm(asm => "DEFC aa=			;; error: syntax error");
z80asm(asm => "DEFC aa=1+1,		;; error: syntax error");

z80asm(asm => "DEFC aa=1+1,bb=2+2	\n DEFB aa,bb	;; 02 04");

#------------------------------------------------------------------------------
# DEFS - simple use tested in opcodes.t
# test error messages here
#------------------------------------------------------------------------------
z80asm(
	asm		=> <<END,
		defs 65536
END
	bin		=> "\x00" x 65536,
);
z80asm(
	asm		=> <<END,
		defb 0
		defs 65535
END
	bin		=> "\x00" x 65536,
);
z80asm(
	asm		=> <<END,
		defs				;; error: syntax error
		defb 0
		defs 65536			;; error: max. code size of 65536 bytes reached
END
);

# test filler byte
z80asm(
	asm		=> " defb 1 \n defs 3 \n defb 2",
	bin		=> pack("C*", 1, 0, 0, 0, 2),
);
z80asm(
	asm		=> " defb 1 \n defs 3, 21 \n defb 2",
	bin		=> pack("C*", 1, 21, 21, 21, 2),
);

z80asm(
	asm		=> " defb 1 \n defs 3 \n defb 2",
	bin		=> pack("C*", 1, 254, 254, 254, 2),
	options	=> "-b --filler=0xFE"
);
z80asm(
	asm		=> " defb 1 \n defs 3, 21 \n defb 2",
	bin		=> pack("C*", 1, 21, 21, 21, 2),
	options	=> "-b --filler=0xFE"
);

z80asm(
	asm		=> " defb 1 \n defs 3 \n defb 2",
	bin		=> pack("C*", 1, 253, 253, 253, 2),
	options	=> "-b --filler=\$FD"
);
z80asm(
	asm		=> " defb 1 \n defs 3 \n defb 2",
	bin		=> pack("C*", 1, 252, 252, 252, 2),
	options	=> "-b --filler=0FCh"
);
z80asm(
	asm		=> " defb 1 \n defs 3 \n defb 2",
	bin		=> pack("C*", 1, 251, 251, 251, 2),
	options	=> "-b --filler=251"
);
z80asm(
	asm		=> " defb 1 \n defs 3 \n defb 2",
	bin		=> pack("C*", 1, 0, 0, 0, 2),
	options	=> "-b --filler=0"
);

z80asm(
	asm		=> " defb 1 ",
	options	=> "-b --filler=-1",
	error	=> "Error: invalid --filler option '-1'",
);
z80asm(
	asm		=> " defb 1 ",
	options	=> "-b --filler=256",
	error	=> "Error: invalid --filler option '256'",
);

#------------------------------------------------------------------------------
# DEFS - simple use tested in opcodes.t
# test error messages here
#------------------------------------------------------------------------------
z80asm(asm => "x1: DEFS 65535,0xAA \n x2: DEFB 0xAA",
	   bin => "\xAA" x 65536);
z80asm(asm => "x1: DEFS 65534,0xAA \n x2: DEFB 0xAA, 0xAA",
	   bin => "\xAA" x 65536);
z80asm(asm => "x1: DEFS 65536,0xAA \n x2: DEFB 0xAA ;; error: max. code size of 65536 bytes reached");
z80asm(asm => "x1: DEFS 65535,0xAA \n x2: DEFB 0xAA, 0xAA ;; error: max. code size of 65536 bytes reached");

#------------------------------------------------------------------------------
# DEFW, DEFQ - simple use tested in opcodes.t
# test error messages here
#------------------------------------------------------------------------------
z80asm(asm => "xx: DEFW 							;; error: syntax error");
z80asm(asm => "xx: DEFW xx, 						;; error: syntax error");
z80asm(asm => "xx: DEFW xx,xx+102h					;; 00 00 02 01");

z80asm(asm => "x1: DEFS 65534,0xAA \n x2: DEFW 0xAAAA",
	   bin => "\xAA" x 65536);
z80asm(asm => "x1: DEFS 65532,0xAA \n x2: DEFW 0xAAAA, 0xAAAA",
	   bin => "\xAA" x 65536);
z80asm(asm => "x1: DEFS 65535,0xAA \n x2: DEFW 0xAAAA ;; error: max. code size of 65536 bytes reached");
z80asm(asm => "x1: DEFS 65533,0xAA \n x2: DEFW 0xAAAA, 0xAAAA ;; error: max. code size of 65536 bytes reached");


z80asm(asm => "xx: DEFQ 							;; error: syntax error");
z80asm(asm => "xx: DEFQ xx, 						;; error: syntax error");
z80asm(asm => "xx: DEFQ xx,xx+1020304h				;; 00 00 00 00 04 03 02 01");

z80asm(asm => "x1: DEFS 65532,0xAA \n x2: DEFQ 0xAAAAAAAA",
	   bin => "\xAA" x 65536);
z80asm(asm => "x1: DEFS 65528,0xAA \n x2: DEFQ 0xAAAAAAAA, 0xAAAAAAAA",
	   bin => "\xAA" x 65536);
z80asm(asm => "x1: DEFS 65533,0xAA \n x2: DEFQ 0xAAAAAAAA ;; error: max. code size of 65536 bytes reached");
z80asm(asm => "x1: DEFS 65529,0xAA \n x2: DEFQ 0xAAAAAAAA, 0xAAAAAAAA ;; error: max. code size of 65536 bytes reached");


#------------------------------------------------------------------------------
# MODULE
#------------------------------------------------------------------------------

# no module directive
z80asm(
	asm 	=> <<'END',
		main: ret	;; C9
END
);
z80nm("test.o", <<'END');

File test.o at $0000: Z80RMF09
  Name: test
  Names:
    L A $0000 main test.asm:1
  Code: 1 bytes
    C $0000: C9
END

# one module directive
z80asm(
	asm 	=> <<'END',
		module lib
		main: ret	;; C9
END
);
z80nm("test.o", <<'END');

File test.o at $0000: Z80RMF09
  Name: lib
  Names:
    L A $0000 main test.asm:2
  Code: 1 bytes
    C $0000: C9
END

# two module directive
z80asm(
	asm 	=> <<'END',
		module lib1
		module lib2
		main: ret	;; C9
END
);
z80nm("test.o", <<'END');

File test.o at $0000: Z80RMF09
  Name: lib2
  Names:
    L A $0000 main test.asm:3
  Code: 1 bytes
    C $0000: C9
END


#------------------------------------------------------------------------------
# ORG
#------------------------------------------------------------------------------

# no ORG defined
z80asm(
	asm		=> "start: jp start ;; C3 00 00",
);

# ORG defined
z80asm(
	asm		=> "org 0x1234 \n start: jp start ;; C3 34 12",
);
z80asm(
	asm		=> "defc org = 0x1234 \n org org \n start: jp start ;; C3 34 12",
);

# ORG defined and overridden by command line
z80asm(
	options	=> "-b -r0x1234",
	asm		=> "org 0x1000 \n start: jp start ;; C3 34 12",
);

# no ORG
z80asm(
	asm		=> "org ;; error: syntax error",
);

# ORG redefined
z80asm(
	asm		=> "org 0x1234 \n org 0x5678 ;; error: ORG redefined",
);

# ORG OK
z80asm(
	asm		=> "org 0 \n jp ASMPC ;; C3 00 00",
);
z80asm(
	asm		=> "org 65535 \n defb ASMPC & 0xFF ;; FF",
);
z80asm(
	asm		=> "org 65535 \n defb ASMPC >> 8 ;; FF",
);

# ORG out of range
z80asm(
	asm		=> "org -2 		;; error: integer '-2' out of range",
);
z80asm(
	asm		=> "org 65536 	;; error: integer '65536' out of range",
);

# ORG not constant
z80asm(
	asm		=> "org start ;; error: symbol 'start' not defined",
);

# -r, --origin -- tested in options.t

# BUG_0025 : JR at org 0 with out-of-range jump crashes WriteListFile()
z80asm(
	asm		=> "jr ASMPC+2-129 ;; error: integer '-129' out of range",
);
z80asm(
	asm		=> "jr ASMPC+2+128 ;; error: integer '128' out of range",
);

# --split-bin, ORG -1
z80asm(
	asm 	=> <<END,
	defw ASMPC
	
	section code
	defw ASMPC
	
	section data
	defw ASMPC
	
	section bss		; split file here
	org 0x4000
	defw ASMPC
END
	bin		=> pack("v*", 0, 2, 4),
);
ok   -f "test.bin";
ok ! -f "test_code.bin";
ok ! -f "test_data.bin";
test_binfile("test_bss.bin", pack("v*", 0x4000));

z80asm(
	options	=> "-b --split-bin",
	asm 	=> <<END,
	defw ASMPC		; split file here
	
	section code	; split file here
	defw ASMPC
	
	section data	; split file here
	defw ASMPC
	
	section bss		; split file here
	org 0x4000
	defw ASMPC
END
	bin		=> pack("v*", 0),
);
ok   -f "test.bin";
test_binfile("test_code.bin", 	pack("v*", 2));
test_binfile("test_data.bin", 	pack("v*", 4));
test_binfile("test_bss.bin", 	pack("v*", 0x4000));

# ORG -1 to split
z80asm(
	options	=> "-b",
	asm 	=> <<END,
	defw ASMPC
	
	section code
	defw ASMPC
	
	section data	; split file here
	org 0x4000
	defw ASMPC
	
	section bss		; split file here
	org -1
	defw ASMPC
END
	bin		=> pack("v*", 0, 2),
);
ok   -f "test.bin";
ok ! -f "test_code.bin";
test_binfile("test_data.bin", 	pack("v*", 0x4000));
test_binfile("test_bss.bin", 	pack("v*", 0x4002));

#------------------------------------------------------------------------------
# EXTERN / PUBLIC
#------------------------------------------------------------------------------
z80asm(
	asm		=> <<'END',
		extern 				;; error: syntax error
		public 				;; error: syntax error
		global 				;; error: syntax error
END
);

z80asm(
	asm		=> <<'END',
		public	p1,p2,p3,p4
		global  g1, g2
		defc g1 = 16, g3 = 48
		global g3, g4
		
	p1:	defb ASMPC			;; 00
	p2:	defb ASMPC			;; 01
	p3:	defb ASMPC			;; 02
	p4:	defb ASMPC			;; 03
		defb g1, g2, g3, g4	;; 10 20 30 40

END
	asm1	=> <<'END',
		extern 	p1,p2,p3,p4
		global  g1, g2
		defc g2 = 32, g4 = 64
		global g3, g4
		
		defb p1,p2,p3,p4	;; 00 01 02 03
		defb g1, g2, g3, g4	;; 10 20 30 40
		
END
);

#------------------------------------------------------------------------------
# LSTON / LSTOFF
#------------------------------------------------------------------------------
z80asm(
	asm		=> <<'END',
		lstoff				;;
		ld bc,1				;; 01 01 00
		lston				;;
		ld hl,1				;; 21 01 00
END
	options => "-b -l",
);
ok -f "test.lis", "test.lis exists";
ok my @lines = read_file("test.lis");
ok $lines[0] =~ /^ 1 \s+ 0000                      \s+ lstoff          /x;
ok $lines[1] =~ /^ 4 \s+ 0003 \s+ 21 \s+ 01 \s+ 00 \s+ ld     \s+ hl,1 /x;
ok $lines[2] =~ /^ 5 \s+ 0006 \s* $/x;

z80asm(
	asm		=> <<'END',
		lstoff				;;
		ld bc,1				;; 01 01 00
		lston				;;
		ld hl,1				;; 21 01 00
END
	options => "-b",
);
ok ! -f "test.lis", "test.lis does not exist";

#------------------------------------------------------------------------------
# IF ELSE ENDIF - simple use tested in opcodes.t
# test error messages here
#------------------------------------------------------------------------------
z80asm(asm => "IF 		;; error: syntax error");
z80asm(asm => "IF 1+	;; error: syntax error");
z80asm(asm => "IF 1",
	   error => "Error at file 'test.asm' line 2: unbalanced control structure started at file 'test.asm' line 1");
z80asm(asm => "ELSE 	;; error: unbalanced control structure");
z80asm(asm => "ENDIF 	;; error: unbalanced control structure");

z80asm(asm => <<'END',
	IF 1 
	ELSE 
	ELSE 	;; error: unbalanced control structure started at file 'test.asm' line 1
	ENDIF
END
);

write_file("test.inc", "IF 1\n");
z80asm(asm => 'INCLUDE "test.inc"',
	   error => "Error at file 'test.inc' line 2: unbalanced control structure started at file 'test.inc' line 1");

z80asm(asm => "IFDEF	;; error: syntax error");
z80asm(asm => "IFDEF 1	;; error: syntax error");
z80asm(asm => "IFDEF hello",
	   error => "Error at file 'test.asm' line 2: unbalanced control structure started at file 'test.asm' line 1");
	   
z80asm(asm => <<'END',
	IFDEF hello 
	ELSE 
	ELSE 	;; error: unbalanced control structure started at file 'test.asm' line 1
	ENDIF
END
);

write_file("test.inc", "IFDEF hello\n");
z80asm(asm => 'INCLUDE "test.inc"',
	   error => "Error at file 'test.inc' line 2: unbalanced control structure started at file 'test.inc' line 1");

z80asm(asm => "IFNDEF	;; error: syntax error");
z80asm(asm => "IFNDEF 1	;; error: syntax error");
z80asm(asm => "IFNDEF hello",
	   error => "Error at file 'test.asm' line 2: unbalanced control structure started at file 'test.asm' line 1");
	   
z80asm(asm => <<'END',
	IFNDEF hello 
	ELSE 
	ELSE 	;; error: unbalanced control structure started at file 'test.asm' line 1
	ENDIF
END
);

write_file("test.inc", "IFNDEF hello\n");
z80asm(asm => 'INCLUDE "test.inc"',
	   error => "Error at file 'test.inc' line 2: unbalanced control structure started at file 'test.inc' line 1");
