#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/1292
# z80asm: Linker support to banked memory
# Test 32-bit addresses

spew("${test}1.asm", <<'END');
	section test1
	org 	$01C000
	public 	func1
	func1: 	ret
	call 	func1
	jp   	func1
END

spew("${test}2.asm", <<'END');
	section test2
	org 	$02C000
	public 	func2
	defb 	0
	func2: 	ret
	call 	func2
	jp   	func2
END

spew("${test}.asm", <<'END');
	section test
	extern func1, func2
	banked_call: ret
	call banked_call
	defq func1
	call banked_call
	defq func2
END

run_ok("z88dk-z80asm -b -m -l ${test}.asm ${test}1.asm ${test}2.asm");

check_bin_file("${test}_test1.bin", pack("C*",
										#	section test1
										#	org 	$01C000
										#	public 	func1
				0xC9,					#	func1: 	ret
				0xCD, 0x00, 0xC0,		#	call 	func1
				0xC3, 0x00, 0xC0,		#	jp   	func1
));

check_bin_file("${test}_test2.bin", pack("C*",
										#	section test2
										#	org 	$02C000
										#	public 	func2
				0,						#	defb 	0
				0xC9,					#	func2: 	ret
				0xCD, 0x01, 0xC0,		#	call 	func2
				0xC3, 0x01, 0xC0,		#	jp   	func2
));

check_bin_file("${test}.bin", pack("C*",
										# 	section test
										#	extern func1, func2
				0xC9,					#	banked_call: ret
				0xCD, 0, 0,				#	call banked_call
				0x00, 0xC0, 0x01, 0x00,	#	defq func1
				0xCD, 0, 0,				#	call banked_call
				0x01, 0xC0, 0x02, 0x00,	#	defq func2
));

check_text_file("${test}.map", <<END);
banked_call                     = \$0000 ; addr, local, , ${test}, test, ${test}.asm:3
func1                           = \$1C000 ; addr, public, , ${test}1, test1, ${test}1.asm:4
func2                           = \$2C001 ; addr, public, , ${test}2, test2, ${test}2.asm:5
__head                          = \$0000 ; const, public, def, , ,
__tail                          = \$2C008 ; const, public, def, , ,
__size                          = \$2C008 ; const, public, def, , ,
__test_head                     = \$0000 ; const, public, def, , ,
__test_tail                     = \$000F ; const, public, def, , ,
__test_size                     = \$000F ; const, public, def, , ,
__test1_head                    = \$1C000 ; const, public, def, , ,
__test1_tail                    = \$1C007 ; const, public, def, , ,
__test1_size                    = \$0007 ; const, public, def, , ,
__test2_head                    = \$2C000 ; const, public, def, , ,
__test2_tail                    = \$2C008 ; const, public, def, , ,
__test2_size                    = \$0008 ; const, public, def, , ,
END

unlink_testfiles;
done_testing;
