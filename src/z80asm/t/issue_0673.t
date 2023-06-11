#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/673
# z80asm: MODULE directive cannot accept names that coincide with register or flag names

z80asm_ok("", "", "", <<END, bytes(1,2));
	module a
	section a
	defb 1
	section b
	defb 2
END

capture_ok("z88dk-z80nm -a ${test}.o", <<END);
Object  file ${test}.o at \$0000: Z80RMF16
  Name: a
  Section a: 1 bytes
    C \$0000: 01
  Section b: 1 bytes
    C \$0000: 02
END

unlink_testfiles;
done_testing;
