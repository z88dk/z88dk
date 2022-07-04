#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

#------------------------------------------------------------------------------
# Bug report: alvin (alvin_albrecht@hotmail.com) <lists@suborbital.org.uk> via lists.sourceforge.net
# date:	Mon, Oct 17, 2016 at 8:11 AM
# For some reason, in pietro_loader.asm, the symbols 
# "__LOADER_head" and "__LOADER_CODE_tail" are
# being made public when a consolidated object is built. 
# It is only those two symbols despite other section symbols being used in 
# the same file.

spew("${test}1.asm", <<'END');
	SECTION LOADER
	EXTERN __LOADER_head, __LOADER_tail
	ld hl, __LOADER_tail -__LOADER_head
END

capture_ok("z88dk-z80asm ${test}1.asm", "");

capture_ok("z88dk-z80nm -a ${test}1.o", <<END);
Object  file ${test}1.o at \$0000: Z80RMF16
  Name: ${test}1
  Section LOADER: 3 bytes
    C \$0000: 21 00 00
  Externs:
    U         __LOADER_head
    U         __LOADER_tail
  Expressions:
    E Cw \$0000 \$0001: __LOADER_tail-__LOADER_head (section LOADER) (file ${test}1.asm:3)
END


capture_ok("z88dk-z80asm -o${test}1.o ${test}1.asm", "");

capture_ok("z88dk-z80nm -a ${test}1.o", <<END);
Object  file ${test}1.o at \$0000: Z80RMF16
  Name: ${test}1
  Section LOADER: 3 bytes
    C \$0000: 21 00 00
  Externs:
    U         __LOADER_head
    U         __LOADER_tail
  Expressions:
    E Cw \$0000 \$0001: __LOADER_tail-__LOADER_head (section LOADER) (file ${test}1.asm:3)
END


unlink_testfiles;
done_testing;
