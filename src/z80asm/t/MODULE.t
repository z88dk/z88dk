#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# no module directive
z80asm_ok("", "", "", <<END, bytes(0xc9));
		main: ret	;; C9
END

capture_ok("z88dk-z80nm -a $test.o", <<END);
Object  file $test.o at \$0000: Z80RMF16
  Name: $test
  Section "": 1 bytes
    C \$0000: C9
  Symbols:
    L A \$0000 main (section "") (file $test.asm:1)
END


# one module directive
z80asm_ok("", "", "", <<END, bytes(0xc9));
		module lib
		main: ret	;; C9
END

capture_ok("z88dk-z80nm -a $test.o", <<END);
Object  file $test.o at \$0000: Z80RMF16
  Name: lib
  Section "": 1 bytes
    C \$0000: C9
  Symbols:
    L A \$0000 main (section "") (file $test.asm:2)
END


# two module directives
z80asm_ok("", "", "", <<END, bytes(0xc9));
		module lib1
		module lib2
		main: ret	;; C9
END

capture_ok("z88dk-z80nm -a $test.o", <<END);
Object  file $test.o at \$0000: Z80RMF16
  Name: lib2
  Section "": 1 bytes
    C \$0000: C9
  Symbols:
    L A \$0000 main (section "") (file $test.asm:3)
END


unlink_testfiles;
done_testing;
