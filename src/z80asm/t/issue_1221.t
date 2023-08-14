#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# https://github.com/z88dk/z88dk/issues/1221
# z80asm: support db, dw, ... as shortcuts to defb, defw, ...

z80asm_ok("", "", "",
          'byte     1'          => bytes(1),
          'db       2'          => bytes(2),
          'defb     3'          => bytes(3),
          'defb     c1, c2'     => bytes(4, 5),
          
          'defm     "hello"'    => "hello",
          'dm       "world"'    => "world",
          
          'defw     0x1234'     => words(0x1234),
          'word     0x1234'     => words(0x1234),
          'dw       0x1234'     => words(0x1234),
          
          'defdb    0x5678'     => words_be(0x5678),
          'ddb      0x5678'     => words_be(0x5678),
          
          'defp     0x123456'   => pointers(0x123456),
          'ptr      0x123456'   => pointers(0x123456),
          'dp       0x123456'   => pointers(0x123456),
          
          'defq     0x12345678' => dwords(0x12345678),
          'dword    0x12345678' => dwords(0x12345678),
          'dq       0x12345678' => dwords(0x12345678),
          
          'defs     2, 0x55'    => bytes(0x55, 0x55),
          'ds       2, 0xaa'    => bytes(0xaa, 0xaa),
          
          'defc     c1 = 4'     => "",
          'dc       c2 = 5'     => "");

capture_ok("z88dk-z80nm -a ${test}.o", <<END);
Object  file ${test}.o at \$0000: Z80RMF18
  Name: ${test}
  CPU:  z80 
  Section "": 50 bytes
    C \$0000: 01 02 03 04 05 68 65 6C 6C 6F 77 6F 72 6C 64 34
    C \$0010: 12 34 12 34 12 56 78 56 78 56 34 12 56 34 12 56
    C \$0020: 34 12 78 56 34 12 78 56 34 12 78 56 34 12 55 55
    C \$0030: AA AA
  Symbols:
    L C \$0004: c1 (section "") (file ${test}.asm:20)
    L C \$0005: c2 (section "") (file ${test}.asm:21)
END

unlink_testfiles;
done_testing;
