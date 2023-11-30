#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2317
# z80asm: incorrect assembly on Rabbit for altd djnz
# check also gbz80/intel djnz emulation

# single module
z80asm_ok("-m8080 -b -l", "", "", 
			"l1:	djnz l1   " 	=> bytes(0x05, 0xc2, 0x00, 0x00),
			"   	djnz ASMPC" 	=> bytes(0x05, 0xc2, 0x04, 0x00),
			);		

z80asm_ok("-mgbz80 -b -l", "", "", 
			"l1:	djnz l1   " 	=> bytes(0x05, 0x20, 0xfd),
			"   	djnz ASMPC" 	=> bytes(0x05, 0x20, 0xfd),
			);		

z80asm_ok("-mr2ka -b -l", "", "", 
			"l1:	altd djnz l1   " => bytes(0x76, 0x10, 0xfd),
			"   	altd djnz ASMPC" => bytes(0x76, 0x10, 0xfd),
			"l2:	djnz l2        " => bytes(      0x10, 0xfe),
			"   	djnz ASMPC     " => bytes(      0x10, 0xfe),
			);		

z80asm_ok("-mz80 -b -l", "", "", 
			"l1:	add hl, l1   " 	=> bytes(0xd5, 0x11, 0x00, 0x00, 0x19, 0xd1),
			"   	add hl, ASMPC" 	=> bytes(0xd5, 0x11, 0x06, 0x00, 0x19, 0xd1),
			);		

# across modules
spew("$test-1.asm", <<END);
			public l1
			l1:
END

spew("$test-2.asm", <<END);
			extern l1
			djnz l1   
			djnz ASMPC
END

capture_ok("z88dk-z80asm -m8080 -l $test-1.asm $test-2.asm", "");
capture_ok("z88dk-z80asm -m8080 -b $test-1.o $test-2.o", "");
check_bin_file("$test-1.bin", bytes(0x05, 0xc2, 0x00, 0x00,
									0x05, 0xc2, 0x04, 0x00));

# across modules
spew("$test-1.asm", <<END);
			public l1
			l1:
END

spew("$test-2.asm", <<END);
			extern l1
			djnz l1   
			djnz ASMPC
END

capture_ok("z88dk-z80asm -mgbz80 -l $test-1.asm $test-2.asm", "");
capture_ok("z88dk-z80asm -mgbz80 -b $test-1.o $test-2.o", "");
check_bin_file("$test-1.bin", bytes(0x05, 0x20, 0xfd,
									0x05, 0x20, 0xfd));

# across modules
spew("$test-1.asm", <<END);
			public l1
			l1:
END

spew("$test-2.asm", <<END);
			extern l1
			altd djnz l1   
			altd djnz ASMPC
			djnz l1        
			djnz ASMPC     
END

capture_ok("z88dk-z80asm -mr2ka -l $test-1.asm $test-2.asm", "");
capture_ok("z88dk-z80asm -mr2ka -b $test-1.o $test-2.o", "");
check_bin_file("$test-1.bin", bytes(0x76, 0x10, 0xfd,
									0x76, 0x10, 0xfd,
									0x10, 0xf8,
									0x10, 0xfe));

# across modules
spew("$test-1.asm", <<END);
			public l1
			l1:
END

spew("$test-2.asm", <<END);
			l1:	add hl, l1   
			   	add hl, ASMPC
END

capture_ok("z88dk-z80asm -mz80 -l $test-1.asm $test-2.asm", "");
capture_ok("z88dk-z80asm -mz80 -b $test-1.o $test-2.o", "");
check_bin_file("$test-1.bin", bytes(0xd5, 0x11, 0x00, 0x00, 0x19, 0xd1,
									0xd5, 0x11, 0x06, 0x00, 0x19, 0xd1));

unlink_testfiles;
done_testing;
