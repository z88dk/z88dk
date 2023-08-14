#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/999
# z80asm: unable to build consolidated object file from c source

spew("${test}a.c", <<'END');
unsigned char fa(void)
{
	return 100;
}
END

spew("${test}b.c", <<'END');
unsigned char fb(void)
{
	return 200;
}
END

run_ok("zcc +zx -c -clib=new ${test}a.c ${test}b.c -o ${test}cons.o");

capture_ok("z88dk-z80nm -a ${test}cons.o", <<END);
Object  file ${test}cons.o at \$0000: Z80RMF18
  Name: ${test}cons
  CPU:  z80 
  Section "": 0 bytes
  Section code_compiler: 8 bytes
    C \$0000: 21 64 00 C9 21 C8 00 C9
  Section bss_compiler: 0 bytes
  Symbols:
    G A \$0000: _fa (section code_compiler) (file ${test}a.c::fa::0::0:2)
    G A \$0004: _fb (section code_compiler) (file ${test}b.c::fb::0::0:2)
END

unlink_testfiles;
done_testing;
