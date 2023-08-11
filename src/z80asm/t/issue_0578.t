#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/578
# z80asm: BINARY directive cannot follow label on same line

spew("${test}1.inc",<<END);
		nop
END

spew("${test}1.bin", bytes(1));

z80asm_ok("-b -m", "", "", <<END, bytes(0,1));
lbl1:	include "${test}1.inc"
lbl2:	binary  "${test}1.bin"
END

capture_ok("z88dk-z80nm -a ${test}.o", <<END);
Object  file ${test}.o at \$0000: Z80RMF18
  Name: ${test}
  CPU:  z80 
  Section "": 2 bytes
    C \$0000: 00 01
  Symbols:
    L A \$0000: lbl1 (section "") (file ${test}.asm:1)
    L A \$0001: lbl2 (section "") (file ${test}.asm:2)
END

unlink_testfiles;
done_testing;
