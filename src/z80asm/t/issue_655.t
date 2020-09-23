#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/655
# z80asm: object file incorrect with correct lis input

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();

build_z80nm();
spew("test.asm", <DATA>);
run("z88dk-z80asm -l test.asm");
open(my $p, "z88dk-z80nm -a test.o|");
my($command_l, $command_h);
my($clearbuf_l, $clearbuf_h);

while (<$p>) {
	/^\s+L C \$([0-9A-F]{2})([0-9A-F]{2}) COMMAND / and ($command_h, $command_l) = ($1, $2);
	/^\s+L C \$([0-9A-F]{2})([0-9A-F]{2}) CLEARBUF / and ($clearbuf_h, $clearbuf_l) = ($1, $2);
	/^\s+Code: \d+ bytes \(section rodata_driver\)/ or next;
	$_ = <$p>;
	s/^\s+//;
	is substr($_,0,32), "C \$0000: 55 C3 $command_l $command_h C3 $clearbuf_l $clearbuf_h AA", ".o file";
	1 while (<$p>);
	last;
}

unlink_testfiles();
done_testing();

__DATA__
SECTION rodata_driver

TESTING1:  	DEFB    $55

DEFC    	ENTRY =	_cpm_bdos_head		; expression does not appear in nm!

_rodata_cpm_ccp_head:

PHASE   0xD800

CBASE:    	JP    COMMAND
			JP    CLEARBUF

TESTING2:  	DEFB    $AA

CLEARBUF:	RET
COMMAND:	RET

ALIGN   0x100

_cpm_bdos_head:

DEPHASE

SECTION bss_user
