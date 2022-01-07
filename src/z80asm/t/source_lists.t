#!/usr/bin/perl

# Z88DK Z80 Module Assembler
#
# Copyright (C) Paulo Custodio, 2011-2022
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test source lists (@files)

use Modern::Perl;
use Test::More;
use File::Path 'make_path';
require './t/testlib.pl';

make_test_files();
run('./z88dk-z80asm -b test1.asm test2.asm test3.asm test4.asm');
check_bin_file("test1.bin", pack("C*", 1..4));

# list file with blank lines and comments
make_test_files();
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

run('./z88dk-z80asm -b test1.asm "@test1.lst"');
check_bin_file("test1.bin", pack("C*", 1..4));

# recursive includes
make_test_files();
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
run('./z88dk-z80asm -b test1.asm "@test1.lst"', 1, "", <<'ERR');
test2.lst:7: error: include recursion: test1.lst
  ^---- @ test1.lst
ERR

# expand environment variables in source and list files
make_test_files();
$ENV{TEST_ENV} = 'test';

run('./z88dk-z80asm -b "${TEST_ENV}1.asm" "${TEST_ENV}2.asm" "${TEST_ENV}3.asm" "${TEST_ENV}4.asm"');
check_bin_file("test1.bin", pack("C*", 1..4));

make_test_files();
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

run('./z88dk-z80asm -b "@test1.lst"');
check_bin_file("test1.bin", pack("C*", 1..4));

# non-existent environment variable is empty
delete $ENV{TEST_ENV};

make_test_files();
run('./z88dk-z80asm -b "te${TEST_ENV}st1.asm" "te${TEST_ENV}st2.asm" "te${TEST_ENV}st3.asm" "te${TEST_ENV}st4.asm"');
check_bin_file("test1.bin", pack("C*", 1..4));

make_test_files();
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

run('./z88dk-z80asm -b "@test1.lst"');
check_bin_file("test1.bin", pack("C*", 1..4));

# use globs in command line
# Note: only relevant for Windows as Unix expands the command line 
# before calling the command
make_test_files("test_dir");
run('./z88dk-z80asm -b "test_dir/*.asm"');
check_bin_file("test_dir/test1.bin", pack("C*", 1..4));

# use globs in list file
make_test_files("test_dir");
spew("test1.lst", <<'END');
	test_dir/*.asm
END
run('./z88dk-z80asm -b "@test1.lst"');
check_bin_file("test_dir/test1.bin", pack("C*", 1..4));

# error if no files are returned
unlink_testfiles();
mkdir("test_dir");
spew("test1.lst", <<'END');
	test_dir/*.asm
END
run('./z88dk-z80asm -b "@test1.lst"', 1, "", <<'ERR');
test1.lst:1: error: pattern returned no files: test_dir/*.asm
  ^---- test_dir/*.asm
ERR

# use globs in recursive list file name
make_test_files("test_dir");
spew("test1.lst", <<'END');
	@ test_dir/*.lst
END
for (1..4) {
	spew("test_dir/test$_.lst", "test_dir/test$_.asm");
}
run('./z88dk-z80asm -b "@test1.lst"');
check_bin_file("test_dir/test1.bin", pack("C*", 1..4));

# use ** glob for any number of directories
unlink_testfiles(); 
mkdir("test_dir");
for (1..4) {
	my $dir = "test_dir/$_/a/b";
	make_path($dir);
	spew("$dir/test$_.asm", "defb $_");
	ok -f "$dir/test$_.asm", "create $dir/test$_.asm"
}
spew("test1.lst", <<'END');
	test_dir/**/*.asm
END
run('./z88dk-z80asm -b "@test1.lst"');
check_bin_file("test_dir/1/a/b/test1.bin", pack("C*", 1..4));

# run again, .o files are not read as asm
run('./z88dk-z80asm -b "@test1.lst"');
check_bin_file("test_dir/1/a/b/test1.bin", pack("C*", 1..4));

unlink_testfiles();
done_testing();

sub make_test_files {
	my($dir) = @_;
	$dir ||= ".";
	
	unlink_testfiles(); 
	mkdir($dir);
	for (1..4) {
		spew("$dir/test$_.asm", "defb $_");
		ok -f "$dir/test$_.asm", "create $dir/test$_.asm"
	}
}
