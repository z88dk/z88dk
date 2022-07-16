#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/563
# z80asm: consolidated object file erroneously eliminates globally exported defc

spew("${test}1.asm",<<END);
		global main1
		extern main

		defc main1 = main
END
spew("${test}2.asm",<<END);
		global main
	main:
		ret
END

capture_ok("z88dk-z80asm -o${test}x.o ${test}1.asm ${test}2.asm", "");

capture_ok("z88dk-z80nm -a ${test}x.o", <<END);
Object  file ${test}x.o at \$0000: Z80RMF16
  Name: ${test}x
  Section "": 1 bytes
    C \$0000: C9
  Symbols:
    G = \$0000 main1 (section "") (file ${test}1.asm:4)
    G A \$0000 main (section "") (file ${test}2.asm:2)
  Expressions:
    E =  \$0000 \$0000: main1 := main (section "") (file ${test}1.asm:4)
END

spew("${test}.asm", <<'END');
		extern main1
		call main1
END

capture_ok("z88dk-z80asm -b ${test}.asm ${test}x.o", "");
check_bin_file("${test}.bin", bytes(0xCD, 0x03, 0x00, 0xC9));

unlink_testfiles;
done_testing;
