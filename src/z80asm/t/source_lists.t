#!/usr/bin/perl

# Z88DK Z80 Module Assembler
#
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test source lists (@files)

use strict;
use warnings;
use v5.10;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();
spew("test1.asm", "defb 1");
spew("test2.asm", "defb 2");
spew("test3.asm", "defb 3");
spew("test4.asm", "defb 4");

run('z80asm -b test1.asm test2.asm test3.asm test4.asm');
check_bin_file("test1.bin", pack("C*", 1..4));
ok unlink "test1.bin";

# list file with blank lines and comments
spew("test1.lst", <<'END');
; comment followed by blank line

# comment
   test2.asm  
@  test2.lst  
END

# list file with different EOL chars
spew("test2.lst", 
	"\r\r\n\n  ".
	"test3.asm".
	"  \r\r\n\n    ".
	"test4.asm".
	"\n");

run('z80asm -b test1.asm @test1.lst');
check_bin_file("test1.bin", pack("C*", 1..4));
ok unlink "test1.bin";

# recursive includes
spew("test1.lst", 
	"\r\r\n\n  ".
	"test2.asm".
	"  \r\r\n\n  \@ ".
	"test2.lst");
	
spew("test2.lst", 
	"\r\r\n\n  ".
	"test2.asm".
	"  \r\r\n\n  \@ ".
	"test1.lst");
run('z80asm -b test1.asm @test1.lst', 1, "", <<'ERR');
Error at file 'test2.lst' line 7: cannot include file 'test1.lst' recursively
1 errors occurred during assembly
ERR

# expand environment variables in source and list files
$ENV{TEST_ENV} = 'test';

run('z80asm -b ${TEST_ENV}1.asm ${TEST_ENV}2.asm ${TEST_ENV}3.asm ${TEST_ENV}4.asm');
check_bin_file("test1.bin", pack("C*", 1..4));
ok unlink "test1.bin";

spew("test1.lst", <<'END');
  ${TEST_ENV}1.asm
  ${TEST_ENV}2.asm

# see #440
@ ${TEST_ENV}2.lst
END

spew("test2.lst", <<'END');
  ${TEST_ENV}3.asm
  ${TEST_ENV}4.asm
END

run('z80asm -b @test1.lst');
check_bin_file("test1.bin", pack("C*", 1..4));
ok unlink "test1.bin";

# non-existent environment variable is empty
delete $ENV{TEST_ENV};

run('z80asm -b te${TEST_ENV}st1.asm te${TEST_ENV}st2.asm te${TEST_ENV}st3.asm te${TEST_ENV}st4.asm');
check_bin_file("test1.bin", pack("C*", 1..4));
ok unlink "test1.bin";

spew("test1.lst", <<'END');
  te${TEST_ENV}st1.asm
  te${TEST_ENV}st2.asm

# see #440
@ te${TEST_ENV}st2.lst
END

spew("test2.lst", <<'END');
  te${TEST_ENV}st3.asm
  te${TEST_ENV}st4.asm
END

run('z80asm -b @test1.lst');
check_bin_file("test1.bin", pack("C*", 1..4));
ok unlink "test1.bin";

unlink_testfiles();
done_testing();
