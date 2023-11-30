#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# BUG_0049: Making a library with -d and 512 (win32) object files fails
# - Too many open files
# limits vary per OS:
# 509 files - when compiled with Visual Studio on Win32
# 3197 files - when compiled with gcc on Cygwin on Win32
# 2045 files - when compiled with gcc on Linux Subsystem for Windows
# 1021 files - when compiled with gcc on Ubuntu

my $NUM_FILES = 4096;

# build asm files
my @list;
my $bin = "";
for my $n (1 .. $NUM_FILES) {
	my $id = sprintf("%04d", $n);
	unlink("${test}_$id.o", "${test}_$id.bin", "${test}_$id.err");
    spew("${test}_$id.asm", <<END);
		public lbl$id
		defw $n
		defc lbl$id = $n
END
    push @list, "${test}_$id";
    $bin .= pack("v", $n);
}

# assemble
unlink "${test}_0001.bin";
spew("${test}.lst", join("\n", @list), "\n");
run_ok("z88dk-z80asm -b \"\@${test}.lst\"");
check_bin_file("${test}_0001.bin", $bin);

# link only
unlink "${test}_0001.bin";
for (@list) { unlink "$_.asm"; }
run_ok("z88dk-z80asm -b \"\@${test}.lst\"");
check_bin_file("${test}_0001.bin", $bin);

# make library
unlink "${test}.lib";
run_ok("z88dk-z80asm -b -x${test} \"\@${test}.lst\"");
ok -f "${test}.lib";

# use library
z80asm_ok("-b -l${test}", "", "", 
          "extern lbl1234;" => "",
          "defw   lbl1234;" => pack("v*", 1234, 1234));

unlink_testfiles;
done_testing;
