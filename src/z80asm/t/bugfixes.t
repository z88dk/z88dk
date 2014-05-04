#!/usr/bin/perl

#     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
#   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
#                ZZZZZ      888           888  0000         0000
#              ZZZZZ        88888888888888888  0000         0000
#            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
#          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
#        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
#      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
#    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
#  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM
#
# Copyright (C) Paulo Custodio, 2011-2014

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/bugfixes.t,v 1.4 2014-05-04 17:36:16 pauloscustodio Exp $
#
# Test bugfixes

use Modern::Perl;
use t::TestZ80asm;

#------------------------------------------------------------------------------
# BUG_0001: Error in expression during link
# BUG_0001(a): during correction of BUG_0001, new symbol 
z80asm(
	asm => 	<<'ASM',
			;; note: BUG_0001
				JP NN			;; C3 06 00
				JP NN			;; C3 06 00
			NN:

			;; note: BUG_0001(a)
				EXTERN value
				ld a,value - 0	;; 3E 0A
ASM

	asm1 => <<'ASM1',
				PUBLIC value
				DEFC   value = 10
ASM1
);

#------------------------------------------------------------------------------
# BUG_0002 : CreateLibFile and GetLibFile: buffer overrun
note "BUG_0002";
$ENV{Z80_STDLIB} = "test.lib";
z80asm(
	asm => <<'ASM',
				PUBLIC one
			one: 
				ld a,1
				ret
ASM
	options => "-x",
	ok		=> 1,
);

z80asm(
	asm =>	<<'ASM',
				EXTERN one
				jp one			;; C3 03 00 3E 01 C9
ASM
	options => "-i -b -r0",
);
delete $ENV{Z80_STDLIB};
unlink_temp("test.lib");

#------------------------------------------------------------------------------
# BUG_0003 : Illegal options are ignored, although ReportError 9 (Illegal Option) exists
note "BUG_0003";
z80asm(
	options => "-h=x",
	error 	=> <<'ERR',
Error: illegal option '-h=x'
Error: source filename missing
ERR
);

#------------------------------------------------------------------------------
# BUG_0004 : 8bit unsigned constants are not checked for out-of-range
note "BUG_0004";
z80asm(
	asm 	=> <<'ASM',
		ld a, -129			;; 3E 7F 		;; warn: integer '-129' out of range
		ld a,256			;; 3E 00 		;; warn: integer '256' out of range
		ld (ix-129),-1		;; DD 36 7F FF	;; warn: integer '-129' out of range
		ld (ix+128),-1		;; DD 36 80 FF	;; warn: integer '128' out of range
ASM
);

#------------------------------------------------------------------------------
# BUG_0049: Making a library with -d and 512 object files fails - Too many open files
{
	my @list;
	my %args;
	for (1..512) {
		my $id = sprintf("%03d", $_);
		unlink("test$id.asm", "test$id.obj", "test$id.bin");
		push @list, "test$id";
		$args{"asm$id"} = "defw $_ ;; ".sprintf("%02X %02X", $_ & 255, $_ >> 8);
	}
	write_file("test.prj", join("\n", @list), "\n");
	
	# assemble all first
	z80asm( %args, options => '   -ns -nm -r0 -b @test.prj' );
	
	# assemble all with -d, make lib - failed with too many open files
	z80asm( %args, options => '-d -ns -nm -r0 -b @test.prj' );
}

#------------------------------------------------------------------------------
# BUG_0050: Making a library with more than 64K and -d option fails - max. code size reached
note "BUG_0050";
z80asm(
	asm1 =>	"defs 65000",
	asm2 =>	"defs 65000",
	options => "-ns -nm",
	ok => 1,
);
z80asm(
	options => "-d -ns -nm test1 test2",
	ok => 1,
);


# $Log: bugfixes.t,v $
# Revision 1.4  2014-05-04 17:36:16  pauloscustodio
# Move tests of BUG_0004 to bugfixes.t
#
# Revision 1.3  2014/05/04 16:48:52  pauloscustodio
# Move tests of BUG_0001 and BUG_0002 to bugfixes.t, using TestZ80asm.pm
#
# Revision 1.2  2014/04/26 09:25:32  pauloscustodio
# BUG_0050: Making a library with more than 64K and -d option fails - max. code size reached
# When a library is built with -d, and the total size of the loaded
# modules is more than 64K, z80asm fails with "max. code size reached".
#
# Revision 1.1  2014/04/26 08:12:04  pauloscustodio
# BUG_0049: Making a library with -d and 512 object files fails - Too many open files
# Error caused by z80asm not closing the intermediate object files, when
# assembling with -d.
#
