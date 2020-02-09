#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2019
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
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
	options	=> ($^O eq 'MSWin32') ? "-b --filler=\$FD" : '-b --filler=\\$FD',	# Note: different quoting
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
	error	=> "Error: invalid filler value: -1",
);
z80asm(
	asm		=> " defb 1 ",
	options	=> "-b --filler=256",
	error	=> "Error: invalid filler value: 256",
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
Object  file test.o at $0000: Z80RMF14
  Name: test
  Section "": 1 bytes
    C $0000: C9
  Symbols:
    L A $0000 main (section "") (file test.asm:1)
END

# one module directive
z80asm(
	asm 	=> <<'END',
		module lib
		main: ret	;; C9
END
);
z80nm("test.o", <<'END');
Object  file test.o at $0000: Z80RMF14
  Name: lib
  Section "": 1 bytes
    C $0000: C9
  Symbols:
    L A $0000 main (section "") (file test.asm:2)
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
Object  file test.o at $0000: Z80RMF14
  Name: lib2
  Section "": 1 bytes
    C $0000: C9
  Symbols:
    L A $0000 main (section "") (file test.asm:3)
END


#------------------------------------------------------------------------------
# EXTERN / PUBLIC
#------------------------------------------------------------------------------
z80asm(
	asm		=> <<'END',
		extern 				;; error: syntax error
		public 				;; error: syntax error
		global 				;; error: syntax error
		xdef 				;; error: syntax error
		xref 				;; error: syntax error
		xlib 				;; error: syntax error
		lib 				;; error: syntax error
END
);

z80asm(
	asm		=> <<'END',
		public	p1,p2
		xdef p3
		xlib p4
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
		extern 	p1,p2
		xref p3
		lib p4
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
