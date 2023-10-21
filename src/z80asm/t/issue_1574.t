#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# https://github.com/z88dk/z88dk/issues/1574
# z80asm -reloc-info fails to recognize subtraction

spew("$test.asm", <<'END');
	foo:
		ld bc,bar - foo
		nop
		nop
	bar:
END

capture_ok("z88dk-z80asm -b -m -reloc-info $test.asm", "");

check_bin_file("$test.bin",
			bytes(0x01, 5, 0, 0, 0));

check_text_file("$test.map", <<END);
foo                             = \$0000 ; addr, local, , $test, , $test.asm:1
bar                             = \$0005 ; addr, local, , $test, , $test.asm:5
__head                          = \$0000 ; const, public, def, , ,
__tail                          = \$0005 ; const, public, def, , ,
__size                          = \$0005 ; const, public, def, , ,
END

capture_ok("z88dk-z80nm -a $test.o", <<END);
Object  file $test.o at \$0000: Z80RMF18
  Name: $test
  CPU:  z80 
  Section "": 5 bytes
    C \$0000: 01 05 00 00 00
  Symbols:
    L A \$0000: foo (section "") (file $test.asm:1)
    L A \$0005: bar (section "") (file $test.asm:5)
END

check_bin_file("$test.reloc", bytes());

unlink_testfiles;
done_testing;
