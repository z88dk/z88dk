#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test loading of z80asm-*.lib

use Modern::Perl;
use Test::More;
use Path::Tiny;
use File::Copy;
use Config;
use Capture::Tiny::Extended 'capture';
require './t/test_utils.pl';

my @RLD_AT_0004 = map {hex} qw( 
	30 05 CD 0B 00 37 C9 07 07 07 07 CB 27
	CB 16 CE 00 17 CB 16 CE 00 17 CB 16 CE 00 17 CB
    16 CE 00 B7 C9 );

path("test.asm")->spew(<<END);
	extern	__z80asm__rld
	call 	__z80asm__rld
	ret
END

# setup sandbox
path('testdir')->remove_tree;
path('testdir/root/bin')->mkpath;
path('testdir/root/lib/config')->mkpath;

# run from current dir
run("./z80asm -b -v test.asm", 0, 
	exp_output("z80", 0, "z80asm-z80-.lib"), "");
t_binary(path("test.bin")->slurp_raw, pack("C*", 0xCD, 0x04, 0x00, 0xC9, @RLD_AT_0004));

# run from bin with lib in the current directory
copy('z80asm'.$Config{_exe}, 'testdir/root/bin/z80asm'.$Config{_exe});
run("testdir/root/bin/z80asm -b -v test.asm", 0, 
	exp_output("z80", 0, "z80asm-z80-.lib"), "");
t_binary(path("test.bin")->slurp_raw, pack("C*", 0xCD, 0x04, 0x00, 0xC9, @RLD_AT_0004));

# run from bin with lib in bin
move('z80asm-z80-.lib', 'testdir/root/bin/z80asm-z80-.lib');
run("testdir/root/bin/z80asm -b -v test.asm", 0, 
	exp_output("z80", 0, "testdir/root/bin//z80asm-z80-.lib"), "");
t_binary(path("test.bin")->slurp_raw, pack("C*", 0xCD, 0x04, 0x00, 0xC9, @RLD_AT_0004));

# run from bin with lib ../lib
move('testdir/root/bin/z80asm-z80-.lib', 'testdir/root/lib/z80asm-z80-.lib');
run("testdir/root/bin/z80asm -b -v test.asm", 0, 
	exp_output("z80", 0, "testdir/root/bin//../lib/z80asm-z80-.lib"), "");
t_binary(path("test.bin")->slurp_raw, pack("C*", 0xCD, 0x04, 0x00, 0xC9, @RLD_AT_0004));

# run from here with lib pointed bt ZCCCFG
$ENV{ZCCCFG} = 'testdir/root/lib/config';
run("./z80asm -b -v test.asm", 0, 
	exp_output("z80", 0, "testdir/root/lib/config/../z80asm-z80-.lib"), "");
t_binary(path("test.bin")->slurp_raw, pack("C*", 0xCD, 0x04, 0x00, 0xC9, @RLD_AT_0004));

# run from here without library
delete $ENV{ZCCCFG};
run("./z80asm -b -v test.asm", 1, <<'OUT', <<'ERR');
Predefined constant: __CPU_Z80__ = $0001
Assembling 'test.asm' to 'test.o'
Reading 'test.asm'
Module 'test' size: 4 bytes

Code size: 4 bytes ($0000 to $0003)
OUT
Error at file 'test.asm' line 2: symbol '__z80asm__rld' not defined
1 errors occurred during assembly
ERR

# restore z80asm-z80-.lib
move('testdir/root/lib/z80asm-z80-.lib', 'z80asm-z80-.lib');

# test loading of each different library for different CPUs
run("./z80asm -b -v                      test.asm", 0, exp_output("z80",	0, "z80asm-z80-.lib"), "");
run("./z80asm -b -v               --IXIY test.asm", 0, exp_output("z80",	1, "z80asm-z80-ixiy.lib"), "");

run("./z80asm -b -v --cpu=z80            test.asm", 0, exp_output("z80",	0, "z80asm-z80-.lib"), "");
run("./z80asm -b -v --cpu=z80     --IXIY test.asm", 0, exp_output("z80",	1, "z80asm-z80-ixiy.lib"), "");

run("./z80asm -b -v --cpu=z80-zxn        test.asm", 0, exp_output("z80_zxn",0, "z80asm-z80_zxn-.lib"), "");
run("./z80asm -b -v --cpu=z80-zxn --IXIY test.asm", 0, exp_output("z80_zxn",1, "z80asm-z80_zxn-ixiy.lib"), "");

run("./z80asm -b -v --cpu=z180            test.asm", 0, exp_output("z180",	0, "z80asm-z180-.lib"), "");
run("./z80asm -b -v --cpu=z180     --IXIY test.asm", 0, exp_output("z180",	1, "z80asm-z180-ixiy.lib"), "");

run("./z80asm -b -v --cpu=r2k             test.asm", 0, exp_output("r2k",	0, "z80asm-r2k-.lib"), "");
run("./z80asm -b -v --cpu=r2k      --IXIY test.asm", 0, exp_output("r2k",	1, "z80asm-r2k-ixiy.lib"), "");

run("./z80asm -b -v --cpu=r3k             test.asm", 0, exp_output("r3k",	0, "z80asm-r3k-.lib"), "");
run("./z80asm -b -v --cpu=r3k      --IXIY test.asm", 0, exp_output("r3k",	1, "z80asm-r3k-ixiy.lib"), "");

path('testdir')->remove_tree;
unlink_testfiles();
done_testing;

sub run {
	my($cmd, $ret, $out, $err) = @_;
	ok 1, $cmd;
	my($stdout, $stderr, $return) = capture { system $cmd; };
	is $stdout, ($out // ""), "stdout";
	is $stderr, ($err // ""), "stderr";
	ok !!$return == !!($ret // 0), "exit value";
}

sub exp_output {
	my($cpu, $swap_ixiy, $library) = @_;
	$cpu = uc($cpu);
	$swap_ixiy = $swap_ixiy ? "\nPredefined constant: __SWAP_IX_IY__ = \$0001" : "";

	
	return <<END;
Reading library '$library'
Predefined constant: __CPU_${cpu}__ = \$0001$swap_ixiy
Assembling 'test.asm' to 'test.o'
Reading 'test.asm'
Module 'test' size: 4 bytes

Linking library module 'rld'
Code size: 38 bytes (\$0000 to \$0025)
Section 'code_crt0_sccz80' size: 34 bytes (\$0004 to \$0025)
END
}
