#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/999
# z80asm: unable to build consolidated object file from c source

use Modern::Perl;
use Test::More;
use Path::Tiny;
require './t/testlib.pl';

path("testa.c")->spew(<<'END');
unsigned char fa(void)
{
	return 100;
}
END

path("testb.c")->spew(<<'END');
unsigned char fb(void)
{
	return 200;
}
END

my $cmd = "zcc +zx -c -clib=new testa.c testb.c -o testcons.o";
ok 0==system($cmd), $cmd;

z80nm("testcons.o", <<'END');
Object  file testcons.o at $0000: Z80RMF14
  Name: testcons
  Section code_compiler: 8 bytes
    C $0000: 21 64 00 C9 21 C8 00 C9
  Section bss_compiler: 0 bytes
  Symbols:
    G A $0000 _fa (section code_compiler) (file testa.c:20)
    G A $0004 _fb (section code_compiler) (file testb.c:20)
END

unlink_testfiles(qw(testa.c testb.c testcons.o));
done_testing();
