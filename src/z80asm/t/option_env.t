#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test Z80ASM environment variable

my $asm = "jp ASMPC";

# no Z80ASM
unlink_testfiles;
delete $ENV{Z80ASM};

z80asm_ok("-b", "", "", $asm, bytes(0xC3, 0, 0));

# with Z80ASM
unlink_testfiles;
$ENV{Z80ASM} = "-r0x8000";

z80asm_ok("-b", "", "", $asm, bytes(0xC3, 0, 0x80));

delete $ENV{Z80ASM};
unlink_testfiles;
done_testing;
