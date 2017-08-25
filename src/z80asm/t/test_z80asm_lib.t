#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test loading of z80asm.lib

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
	extern __z80asm__rld
	call __z80asm__rld
	ret
END

# setup sandbox
path('test')->remove_tree;
path('test/root/bin')->mkpath;
path('test/root/lib/config')->mkpath;

# run from current dir
run("./z80asm -b -v test.asm", 0, <<'END', "");
Reading library 'z80asm.lib'
Assembling 'test.asm' to 'test.o'
Reading 'test.asm'
Module 'test' size: 4 bytes

Linking library module 'z80asm_rld'
Code size: 38 bytes ($0000 to $0025)
END
t_binary(path("test.bin")->slurp_raw, pack("C*", 0xCD, 0x04, 0x00, 0xC9, @RLD_AT_0004));

# run from bin with lib in the current directory
copy('z80asm'.$Config{_exe}, 'test/root/bin/z80asm'.$Config{_exe});
run("test/root/bin/z80asm -b -v test.asm", 0, <<'END', "");
Reading library 'z80asm.lib'
Assembling 'test.asm' to 'test.o'
Reading 'test.asm'
Module 'test' size: 4 bytes

Linking library module 'z80asm_rld'
Code size: 38 bytes ($0000 to $0025)
END
t_binary(path("test.bin")->slurp_raw, pack("C*", 0xCD, 0x04, 0x00, 0xC9, @RLD_AT_0004));

# run from bin with lib in bin
move('z80asm.lib', 'test/root/bin/z80asm.lib');
run("test/root/bin/z80asm -b -v test.asm", 0, <<'END', "");
Reading library 'test/root/bin//z80asm.lib'
Assembling 'test.asm' to 'test.o'
Reading 'test.asm'
Module 'test' size: 4 bytes

Linking library module 'z80asm_rld'
Code size: 38 bytes ($0000 to $0025)
END
t_binary(path("test.bin")->slurp_raw, pack("C*", 0xCD, 0x04, 0x00, 0xC9, @RLD_AT_0004));

# run from bin with lib ../lib
move('test/root/bin/z80asm.lib', 'test/root/lib/z80asm.lib');
run("test/root/bin/z80asm -b -v test.asm", 0, <<'END', "");
Reading library 'test/root/bin//../lib/z80asm.lib'
Assembling 'test.asm' to 'test.o'
Reading 'test.asm'
Module 'test' size: 4 bytes

Linking library module 'z80asm_rld'
Code size: 38 bytes ($0000 to $0025)
END
t_binary(path("test.bin")->slurp_raw, pack("C*", 0xCD, 0x04, 0x00, 0xC9, @RLD_AT_0004));

# run from here with lib pointed bt ZCCCFG
$ENV{ZCCCFG} = 'test/root/lib/config';
run("./z80asm -b -v test.asm", 0, <<'END', "");
Reading library 'test/root/lib/config/../z80asm.lib'
Assembling 'test.asm' to 'test.o'
Reading 'test.asm'
Module 'test' size: 4 bytes

Linking library module 'z80asm_rld'
Code size: 38 bytes ($0000 to $0025)
END
t_binary(path("test.bin")->slurp_raw, pack("C*", 0xCD, 0x04, 0x00, 0xC9, @RLD_AT_0004));

# run from here without library
delete $ENV{ZCCCFG};
run("./z80asm -b -v test.asm", 1, <<'OUT', <<'ERR');
Assembling 'test.asm' to 'test.o'
Reading 'test.asm'
Module 'test' size: 4 bytes

Code size: 4 bytes ($0000 to $0003)
OUT
Error at file 'test.asm' line 2: symbol '__z80asm__rld' not defined
1 errors occurred during assembly
ERR

# restore z80asm.lib
move('test/root/lib/z80asm.lib', 'z80asm.lib');

path('test')->remove_tree;
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

