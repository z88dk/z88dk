#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Test https://github.com/z88dk/z88dk/issues/194
# z80asm: wrong assembly of DDCB with no index

use Modern::Perl;
use Capture::Tiny::Extended 'capture';
use t::TestZ80asm;
use t::Listfile;

my($out, $err, $exit);

unlink "test.o", "test.bin", "test.lis";
write_file("test.asm", <<'END');
 rlc (ix+0)
 rlc (ix)
END
($out, $err, $exit) = capture { system "./z80asm -b -l test.asm"; };
is $out, "";
is $err, "";
is $exit, 0;
test_binfile("test.bin", 		pack("C*", (0xDD, 0xCB, 0x00, 0x06) x 2));

