#!/usr/bin/perl

#-----------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2020
# License: http://www.perlfoundation.org/artistic_license_2_0
#
# BUG_0049: Making a library with -d and 512 (win32) object files fails
# - Too many open files
# limits very per OS:
# 509 files - when compiled with Visual Studio on Win32
# 3197 files - when compiled with gcc on Cygwin on Win32
# 2045 files - when compiled with gcc on Linux Subsystem for Windows
# 1021 files - when compiled with gcc on Ubuntu
#-----------------------------------------------------------------------------

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();

# build asm files
my @list;
my $bin = "";
for my $n (1..4096) {
	my $id = sprintf("%04d", $n);
	unlink("test$id.o", "test$id.bin", "test$id.err");
	spew("test$id.asm", <<END);
		public lbl$id
		defw $n
		defc lbl$id = $n
END
		push @list, "test$id";
		
		$bin .= pack("v", $n);
	}
	
# assemble
unlink 'test0001.bin';
spew("test.lst", join("\n", @list), "\n");
run('./z88dk-z80asm -b "@test.lst"');
check_bin_file('test0001.bin', $bin);

# link only
unlink 'test0001.bin';
for (@list) { unlink "$_.asm"; }
run('./z88dk-z80asm -b "@test.lst"');
check_bin_file('test0001.bin', $bin);

# make library
unlink 'test.lib';
run('./z88dk-z80asm -b -xtest "@test.lst"');
ok -f 'test.lib';

# use library
unlink 'test.bin';
z80asm(<<'END', '-b -ltest');
	extern lbl1234;
	defw lbl1234;
END
check_bin_file('test.bin', pack("v*", 1234, 1234));

# delete test files
for ('test', @list) { unlink "$_.asm", "$_.o", "$_.bin", "$_.err", "$_.lib"; }

unlink_testfiles();
done_testing();
