#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

#------------------------------------------------------------------------------
# Test library with specialized and generalized version of same function

unlink_testfiles;

spew("${test}gen.asm", <<'END');
		global putpixel

	putpixel:
		ld a, 1
		ret
END

# platform 1 uses the generic putpixel
spew("${test}plat1.asm", <<'END');
END

# make platform 1 library
capture_ok("z88dk-z80asm -x${test}plat1.lib ${test}plat1.asm ${test}gen.asm", "");

capture_ok("z88dk-z80nm -a ${test}plat1.lib", <<END);
Library file ${test}plat1.lib at \$0000: Z80LMF18
Object  file ${test}plat1.lib at \$0014: Z80RMF18
  Name: ${test}plat1
  CPU:  z80 
  Section "": 0 bytes

Object  file ${test}plat1.lib at \$008C: Z80RMF18
  Name: ${test}gen
  CPU:  z80 
  Section "": 3 bytes
    C \$0000: 3E 01 C9
  Symbols:
    G A \$0000: putpixel (section "") (file ${test}gen.asm:3)

END


# platform 2 uses a specific putpixel
spew("${test}plat2.asm", <<'END');
		global putpixel

	putpixel:
		ld a, 2
		ret
END

# make platform 2 library
capture_ok("z88dk-z80asm -x${test}plat2.lib ${test}plat2.asm ${test}gen.asm", "");

capture_ok("z88dk-z80nm -a ${test}plat1.lib", <<END);
Library file ${test}plat1.lib at \$0000: Z80LMF18
Object  file ${test}plat1.lib at \$0014: Z80RMF18
  Name: ${test}plat1
  CPU:  z80 
  Section "": 0 bytes

Object  file ${test}plat1.lib at \$008C: Z80RMF18
  Name: ${test}gen
  CPU:  z80 
  Section "": 3 bytes
    C \$0000: 3E 01 C9
  Symbols:
    G A \$0000: putpixel (section "") (file ${test}gen.asm:3)

END


# generic source
spew("${test}.asm", <<'END');
		global putpixel
		jp putpixel
END


# link on platform 1
unlink("${test}.bin");
capture_ok("z88dk-z80asm -l${test}plat1.lib -b ${test}.asm", "");
check_bin_file("${test}.bin", bytes(0xC3, 3, 0, 0x3E, 1, 0xC9));


# link on platform 2
unlink("${test}.bin");
capture_ok("z88dk-z80asm -l${test}plat2.lib -b ${test}.asm", "");
check_bin_file("${test}.bin", bytes(0xC3, 3, 0, 0x3E, 2, 0xC9));


unlink_testfiles;
done_testing;
