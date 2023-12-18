#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/270
# z80asm: ignoring org -1 for sections when data is in object file separate from memory map file


for my $one_step (0, 1) {
	unlink_testfiles;
	spew("${test}1.asm", <<END);
		SECTION CODE
		org 0

		SECTION DATA
		org 0x8000

		SECTION BSS
		org -1
END
	
	spew("${test}2.asm", <<END);
		SECTION CODE
		defb 1,2,3,4,5

		SECTION DATA
		defb 10,11,12,13

		SECTION BSS
		defs 3
END

	if ($one_step) {
		capture_ok("z88dk-z80asm -b -o${test} -m ${test}1.asm ${test}2.asm", "");
	}
	else {
		capture_ok("z88dk-z80asm ${test}1.asm", "");
		capture_ok("z88dk-z80asm ${test}2.asm", "");
		capture_ok("z88dk-z80asm -b -o${test} -m ${test}1.o ${test}2.o", "");
	}

	check_bin_file("${test}_CODE.bin",	bytes(1, 2, 3, 4, 5));
	check_bin_file("${test}_DATA.bin",	bytes(10, 11, 12, 13));
	check_bin_file("${test}_BSS.bin", 	bytes(0, 0, 0));
	check_text_file("${test}.map", <<'END');
__head                          = $0000 ; const, public, def, , ,
__tail                          = $8007 ; const, public, def, , ,
__size                          = $8007 ; const, public, def, , ,
__CODE_head                     = $0000 ; const, public, def, , ,
__CODE_tail                     = $0005 ; const, public, def, , ,
__CODE_size                     = $0005 ; const, public, def, , ,
__DATA_head                     = $8000 ; const, public, def, , ,
__DATA_tail                     = $8004 ; const, public, def, , ,
__DATA_size                     = $0004 ; const, public, def, , ,
__BSS_head                      = $8004 ; const, public, def, , ,
__BSS_tail                      = $8007 ; const, public, def, , ,
__BSS_size                      = $0003 ; const, public, def, , ,
END
}


# C test code that causes failure
SKIP: {
	skip "z88dk-zsdcc not found, test skipped", 1
		unless -f "../../bin/z88dk-zsdcc$Config{_exe}";
	skip "only run with DEVELOPER=1", 1
		unless $ENV{DEVELOPER};			# fails in snapcraft tests

	unlink_testfiles;
	spew("${test}.c", <<'END');
		// DATA
		unsigned char data[] = "Hello";

		// BSS
		unsigned buffer[100];

		// CODE
		int main(void)
		{
			return 1;
		}
END

	run_ok("zcc +z80 -clib=sdcc_iy ${test}.c -o ${test}.bin -m");

	ok -f "${test}_CODE.bin", "${test}_CODE.bin exists";
	ok -s "${test}_CODE.bin" >= 4, "${test}_CODE.bin size OK";
	my $code = slurp("${test}_CODE.bin");
	ok $code =~ /\x21\x01\x00\xc9\x00\z/, "${test}_CODE.bin contents";

	ok -f "${test}_DATA.bin", "${test}_DATA.bin exists";
	ok -s "${test}_DATA.bin" >= 6, "${test}_DATA.bin size OK";
	my $data = slurp("${test}_DATA.bin");
	ok $data =~ /Hello\0\z/, "${test}_DATA.bin contents";

	ok -f "${test}_BSS.bin", "${test}_BSS.bin exists";
	ok -s "${test}_BSS.bin" >= 200, "${test}_BSS.bin size OK";
	my $bss = slurp("${test}_BSS.bin");
	my $buffer = "\0" x 200;
	ok $bss =~ /$buffer\z/, "${test}_BSS.bin contents";
}

# reduce C exmaple above to minimum that reproduces failure
unlink_testfiles;

spew("${test}1.asm", <<'END');
	section CODE
	ORG $0000
	
	section code_compiler

	section DATA
	ORG $8000
	
	section data_compiler
	
	section BSS
	ORG -1 ; section split

	section bss_compiler
END

spew("${test}2.asm", <<'END');
	section bss_compiler
	defs 100*2, 0

	section code_compiler
	ld hl, 1
	ret

	section data_compiler
	defb "Hello", 0
END

capture_ok("z88dk-z80asm ${test}1.asm", "");
capture_ok("z88dk-z80asm ${test}2.asm", "");
capture_ok("z88dk-z80asm -b -o${test}.bin -m ${test}1.o ${test}2.o", "");

ok -f "${test}_CODE.bin", "${test}_CODE.bin exists";
ok -s "${test}_CODE.bin" >= 4, "${test}_CODE.bin size OK";
my $code = slurp("${test}_CODE.bin");
ok $code =~ /\x21\x01\x00\xc9\z/, "${test}_CODE.bin contents";

ok -f "${test}_DATA.bin", "${test}_DATA.bin exists";
ok -s "${test}_DATA.bin" >= 6, "${test}_DATA.bin size OK";
my $data = slurp("${test}_DATA.bin");
ok $data =~ /Hello\0\z/, "${test}_DATA.bin contents";

ok -f "${test}_BSS.bin", "${test}_BSS.bin exists";
ok -s "${test}_BSS.bin" >= 200, "${test}_BSS.bin size OK";
my $bss = slurp("${test}_BSS.bin");
my $buffer = "\0" x 200;
ok $bss =~ /$buffer\z/, "${test}_BSS.bin contents";


unlink_testfiles;
done_testing;
