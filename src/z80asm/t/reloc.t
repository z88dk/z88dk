#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2019
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#
# Test options

use strict;
use warnings;
use CPU::Z80::Assembler (); #$CPU::Z80::Assembler::verbose = 1;
use Test::Differences; 
use Test::More;
use Data::Dump 'dump';
require './t/test_utils.pl';

# copied from z80asm.c:
# unsigned char reloc_routine[] =
my $reloc_routine =
	"\x08\xD9\xFD\xE5\xE1\x01\x49\x00\x09\x5E\x23\x56\xD5\x23\x4E\x23".
	"\x46\x23\xE5\x09\x44\x4D\xE3\x7E\x23\xB7\x20\x06\x5E\x23\x56\x23".
	"\x18\x03\x16\x00\x5F\xE3\x19\x5E\x23\x56\xEB\x09\xEB\x72\x2B\x73".
	"\xD1\xE3\x2B\x7C\xB5\xE3\xD5\x20\xDD\xF1\xF1\xFD\x36\x00\xC3\xFD".
	"\x71\x01\xFD\x70\x02\xD9\x08\xFD\xE9";

#------------------------------------------------------------------------------
# -R, --relocatable
#------------------------------------------------------------------------------

t_reloc("start: jp start");
t_reloc("start: defw start,start,start");
for (253..257) {
	t_reloc("start: defb 0".(",0" x $_)."\ndefw start,start,start");
}

#------------------------------------------------------------------------------
# test reloc with sections
#------------------------------------------------------------------------------
sub code_asm {
	my($n) = @_;
	return <<"...";
	start$n:
		ld bc,string
		ld de,string1
		ld hl,string2
		call start
		call start1
		call start2
...
}
sub data_asm {
	my($n) = @_;
	return <<"...";
	string$n:
		defm "hello${n}world"
...
}

#------------------------------------------------------------------------------
# without --relocatable, one module
#------------------------------------------------------------------------------
my $code_addr = 0x1020;
my $data_addr = 0x3040;
my $asm = "section code\norg $code_addr\n".code_asm("").
		  "section data\norg $data_addr\n".data_asm("").
		  "section code\n".code_asm("1").
		  "section data\n".data_asm("1").
		  "section code\n".code_asm("2").
		  "section data\n".data_asm("2");

unlink_testfiles();
write_file("test.asm", $asm);
t_z80asm_capture("-b -m --reloc-info test.asm", "", "", 0);
ok ! -f "test.bin";
ok ! -f "test.reloc";

t_binary(read_binfile("test_code.bin"), 
		CPU::Z80::Assembler::z80asm("org $code_addr\n".
									"string  equ $data_addr\n".
									"string1 equ ".($data_addr + 10)."\n".
									"string2 equ ".($data_addr + 10 + 11)."\n".
									code_asm("").code_asm("1").code_asm("2")));
t_binary(read_binfile("test_code.reloc"), 
		pack("v*", reloc_addrs(code_asm("").code_asm("1").code_asm("2").
							   "string:\nstring1:\nstring2:\n")));
							   
t_binary(read_binfile("test_data.bin"), 
		CPU::Z80::Assembler::z80asm(data_asm("").data_asm("1").data_asm("2")));
ok ! -f "test.reloc";

is_text( scalar(read_file("test.map")), <<'...', "mapfile contents" );
start                           = $1020 ; addr, local, , test, code, test.asm:3
string                          = $3040 ; addr, local, , test, data, test.asm:12
string1                         = $304A ; addr, local, , test, data, test.asm:23
string2                         = $3055 ; addr, local, , test, data, test.asm:34
start1                          = $1032 ; addr, local, , test, code, test.asm:15
start2                          = $1044 ; addr, local, , test, code, test.asm:26
__head                          = $0000 ; const, public, def, , ,
__tail                          = $3060 ; const, public, def, , ,
__size                          = $3060 ; const, public, def, , ,
__code_head                     = $1020 ; const, public, def, , ,
__code_tail                     = $1056 ; const, public, def, , ,
__code_size                     = $0036 ; const, public, def, , ,
__data_head                     = $3040 ; const, public, def, , ,
__data_tail                     = $3060 ; const, public, def, , ,
__data_size                     = $0020 ; const, public, def, , ,
...

#------------------------------------------------------------------------------
# with --relocatable, one module
#------------------------------------------------------------------------------
unlink_testfiles();
write_file("test.asm", $asm);

$asm = code_asm("").code_asm("1").code_asm("2").
	   data_asm("").data_asm("1").data_asm("2");
my @reloc = reloc_addrs($asm);
my $reloc_header = reloc_header(@reloc);

t_z80asm_capture("-b -m --relocatable test.asm", 
				 "Relocation header is ".length($reloc_header)." bytes.\n", <<'ERR', 0);
Warning at module 'test': ORG ignored at file 'test.o', section 'code'
Warning at module 'test': ORG ignored at file 'test.o', section 'data'
ERR

t_binary(read_binfile("test.bin"), $reloc_header.CPU::Z80::Assembler::z80asm("org 0\n".$asm));
ok ! -f "test.reloc";

ok ! -f "test_code.bin";
ok ! -f "test_code.reloc";
ok ! -f "test_data.bin";
ok ! -f "test_data.reloc";

is_text( scalar(read_file("test.map")), <<'...', "mapfile contents" );
start                           = $005F ; addr, local, , test, code, test.asm:3
string                          = $0095 ; addr, local, , test, data, test.asm:12
string1                         = $009F ; addr, local, , test, data, test.asm:23
string2                         = $00AA ; addr, local, , test, data, test.asm:34
start1                          = $0071 ; addr, local, , test, code, test.asm:15
start2                          = $0083 ; addr, local, , test, code, test.asm:26
__head                          = $005F ; const, public, def, , ,
__tail                          = $00B5 ; const, public, def, , ,
__size                          = $00B5 ; const, public, def, , ,
__code_head                     = $005F ; const, public, def, , ,
__code_tail                     = $0095 ; const, public, def, , ,
__code_size                     = $0095 ; const, public, def, , ,
__data_head                     = $0095 ; const, public, def, , ,
__data_tail                     = $00B5 ; const, public, def, , ,
__data_size                     = $007F ; const, public, def, , ,
...

#------------------------------------------------------------------------------
# without --relocatable, several modules
#------------------------------------------------------------------------------
unlink_testfiles();
write_file("test.asm", 
		"section code\norg $code_addr\n".
		"public start,string\nextern start,start1,start2,string,string1,string2\n".
		code_asm("").
		"section data\norg $data_addr\n".
		data_asm(""));
write_file("test1.asm", 
		"section code\n".
		"public start1,string1\nextern start,start1,start2,string,string1,string2\n".
		code_asm("1").
		"section data\n".
		data_asm("1"));
write_file("test2.asm", 
		"section code\n".
		"public start2,string2\nextern start,start1,start2,string,string1,string2\n".
		code_asm("2").
		"section data\n".
		data_asm("2"));
t_z80asm_capture("-b -m --reloc-info test.asm test1.asm test2.asm", "", "", 0);
ok ! -f "test.bin";
ok ! -f "test.reloc";

t_binary(read_binfile("test_code.bin"), 
		CPU::Z80::Assembler::z80asm("org $code_addr\n".
									"string  equ $data_addr\n".
									"string1 equ ".($data_addr + 10)."\n".
									"string2 equ ".($data_addr + 10 + 11)."\n".
									code_asm("").code_asm("1").code_asm("2")));
t_binary(read_binfile("test_code.reloc"), 
		pack("v*", reloc_addrs(code_asm("").code_asm("1").code_asm("2").
							   "string:\nstring1:\nstring2:\n")));
							   
t_binary(read_binfile("test_data.bin"), 
		CPU::Z80::Assembler::z80asm(data_asm("").data_asm("1").data_asm("2")));
t_binary(read_binfile("test_data.reloc"), "");

is_text( scalar(read_file("test.map")), <<'...', "mapfile contents" );
start                           = $1020 ; addr, public, , test, code, test.asm:5
string                          = $3040 ; addr, public, , test, data, test.asm:14
start1                          = $1032 ; addr, public, , test1, code, test1.asm:4
string1                         = $304A ; addr, public, , test1, data, test1.asm:12
start2                          = $1044 ; addr, public, , test2, code, test2.asm:4
string2                         = $3055 ; addr, public, , test2, data, test2.asm:12
__head                          = $0000 ; const, public, def, , ,
__tail                          = $3060 ; const, public, def, , ,
__size                          = $3060 ; const, public, def, , ,
__code_head                     = $1020 ; const, public, def, , ,
__code_tail                     = $1056 ; const, public, def, , ,
__code_size                     = $0036 ; const, public, def, , ,
__data_head                     = $3040 ; const, public, def, , ,
__data_tail                     = $3060 ; const, public, def, , ,
__data_size                     = $0020 ; const, public, def, , ,
...

#------------------------------------------------------------------------------
# with --relocatable, several modules
#------------------------------------------------------------------------------
unlink_testfiles();
write_file("test.asm", 
		"section code\norg $code_addr\n".
		"public start,string\nextern start,start1,start2,string,string1,string2\n".
		code_asm("").
		"section data\norg $data_addr\n".
		data_asm(""));
write_file("test1.asm", 
		"section code\n".
		"public start1,string1\nextern start,start1,start2,string,string1,string2\n".
		code_asm("1").
		"section data\n".
		data_asm("1"));
write_file("test2.asm", 
		"section code\n".
		"public start2,string2\nextern start,start1,start2,string,string1,string2\n".
		code_asm("2").
		"section data\n".
		data_asm("2"));

$asm = code_asm("").code_asm("1").code_asm("2").
	   data_asm("").data_asm("1").data_asm("2");
@reloc = reloc_addrs($asm);
$reloc_header = reloc_header(@reloc);

t_z80asm_capture("-b -m --relocatable test.asm test1.asm test2.asm", 
				 "Relocation header is ".length($reloc_header)." bytes.\n", <<'ERR', 0);
Warning at module 'test': ORG ignored at file 'test.o', section 'code'
Warning at module 'test': ORG ignored at file 'test.o', section 'data'
Warning at module 'test1': ORG ignored at file 'test1.o', section 'code'
Warning at module 'test1': ORG ignored at file 'test1.o', section 'data'
Warning at module 'test2': ORG ignored at file 'test2.o', section 'code'
Warning at module 'test2': ORG ignored at file 'test2.o', section 'data'
ERR

t_binary(read_binfile("test.bin"), $reloc_header.CPU::Z80::Assembler::z80asm("org 0\n".$asm));
ok ! -f "test.reloc";

ok ! -f "test_code.bin";
ok ! -f "test_code.reloc";
ok ! -f "test_data.bin";
ok ! -f "test_data.reloc";

is_text( scalar(read_file("test.map")), <<'...', "mapfile contents" );
start                           = $005F ; addr, public, , test, code, test.asm:5
string                          = $0095 ; addr, public, , test, data, test.asm:14
start1                          = $0071 ; addr, public, , test1, code, test1.asm:4
string1                         = $009F ; addr, public, , test1, data, test1.asm:12
start2                          = $0083 ; addr, public, , test2, code, test2.asm:4
string2                         = $00AA ; addr, public, , test2, data, test2.asm:12
__head                          = $005F ; const, public, def, , ,
__tail                          = $00B5 ; const, public, def, , ,
__size                          = $00B5 ; const, public, def, , ,
__code_head                     = $005F ; const, public, def, , ,
__code_tail                     = $0095 ; const, public, def, , ,
__code_size                     = $0095 ; const, public, def, , ,
__data_head                     = $0095 ; const, public, def, , ,
__data_tail                     = $00B5 ; const, public, def, , ,
__data_size                     = $007F ; const, public, def, , ,
...

#------------------------------------------------------------------------------
# without --relocatable, several sections
#------------------------------------------------------------------------------
unlink_testfiles();
write_file("test.asm", <<"...".
	section code
	section code1
	section code2
	section data
	section data1
	section data2
	section code
	org $code_addr
	section data
	org $data_addr
...
	"section code\n" .code_asm("").
	"section code1\n".code_asm("1").
	"section code2\n".code_asm("2").
	"section data\n" .data_asm("").
	"section data1\n".data_asm("1").
	"section data2\n".data_asm("2"));
t_z80asm_capture("-b -m --reloc-info test.asm", "", "", 0);
ok ! -f "test.bin";
ok ! -f "test.reloc";

t_binary(read_binfile("test_code.bin"), 
		CPU::Z80::Assembler::z80asm("org $code_addr\n".
									"string  equ $data_addr\n".
									"string1 equ ".($data_addr + 10)."\n".
									"string2 equ ".($data_addr + 10 + 11)."\n".
									code_asm("").code_asm("1").code_asm("2")));
t_binary(read_binfile("test_code.reloc"), 
		pack("v*", reloc_addrs(code_asm("").code_asm("1").code_asm("2").
							   "string:\nstring1:\nstring2:\n")));

ok ! -f "test_code1.bin";
ok ! -f "test_code1.reloc";
ok ! -f "test_code2.bin";
ok ! -f "test_code2.reloc";

t_binary(read_binfile("test_data.bin"), 
		CPU::Z80::Assembler::z80asm(data_asm("").data_asm("1").data_asm("2")));
t_binary(read_binfile("test_data.reloc"), "");

ok ! -f "test_data1.bin";
ok ! -f "test_data1.reloc";
ok ! -f "test_data2.bin";
ok ! -f "test_data2.reloc";

is_text( scalar(read_file("test.map")), <<'...', "mapfile contents" );
start                           = $1020 ; addr, local, , test, code, test.asm:12
string                          = $3040 ; addr, local, , test, data, test.asm:36
string1                         = $304A ; addr, local, , test, data1, test.asm:39
string2                         = $3055 ; addr, local, , test, data2, test.asm:42
start1                          = $1032 ; addr, local, , test, code1, test.asm:20
start2                          = $1044 ; addr, local, , test, code2, test.asm:28
__head                          = $0000 ; const, public, def, , ,
__tail                          = $3060 ; const, public, def, , ,
__size                          = $3060 ; const, public, def, , ,
__code_head                     = $1020 ; const, public, def, , ,
__code_tail                     = $1032 ; const, public, def, , ,
__code_size                     = $0012 ; const, public, def, , ,
__code1_head                    = $1032 ; const, public, def, , ,
__code1_tail                    = $1044 ; const, public, def, , ,
__code1_size                    = $0012 ; const, public, def, , ,
__code2_head                    = $1044 ; const, public, def, , ,
__code2_tail                    = $1056 ; const, public, def, , ,
__code2_size                    = $0012 ; const, public, def, , ,
__data_head                     = $3040 ; const, public, def, , ,
__data_tail                     = $304A ; const, public, def, , ,
__data_size                     = $000A ; const, public, def, , ,
__data1_head                    = $304A ; const, public, def, , ,
__data1_tail                    = $3055 ; const, public, def, , ,
__data1_size                    = $000B ; const, public, def, , ,
__data2_head                    = $3055 ; const, public, def, , ,
__data2_tail                    = $3060 ; const, public, def, , ,
__data2_size                    = $000B ; const, public, def, , ,
...

unlink_testfiles();
done_testing();

#------------------------------------------------------------------------------
# test with and without -R
#------------------------------------------------------------------------------
sub t_reloc {
	my($asm) = @_;

	ok 1, "line ".(caller)[2];
	
	my($bin0, $bin1, $reloc_header, @reloc) = compute_reloc_addrs($asm);
	
	# -R
	for my $options ('-R', '--relocatable', '--relocatable --reloc-info') {
		unlink_testfiles();
		write_file("test.asm", $asm);
		
		t_z80asm_capture("-b $options test.asm", 
						 "Relocation header is ".length($reloc_header)." bytes.\n", "", 0);
						 
		t_binary(read_binfile("test.bin"), $reloc_header.$bin0);
		ok ! -f "test.reloc";
	}

	# no -R, no --reloc-info
	unlink_testfiles();
	write_file("test.asm", "org 1\n".$asm);
	
	t_z80asm_capture("-b test.asm", "", "", 0);
	t_binary(read_binfile("test.bin"), $bin1);
	ok ! -f "test.reloc";
	
	# no -R, --reloc-info
	unlink_testfiles();
	write_file("test.asm", "org 1\n".$asm);
	
	t_z80asm_capture("-b --reloc-info test.asm", "", "", 0);
	t_binary(read_binfile("test.bin"), $bin1);
	t_binary(read_binfile("test.reloc"), pack("v*", @reloc));
}	

# compute reloc addresses and bin files at org 0 and 1
sub reloc_addrs {
	my($asm) = @_;
	
	# identify reloc addresses
	my $bin0 = CPU::Z80::Assembler::z80asm("org 0\n".$asm);
	my $bin1 = CPU::Z80::Assembler::z80asm("org 1\n".$asm);
	
	my @addrs;
	for (my $addr = 0; $addr < length($bin0)-1; $addr++) {
		if (substr($bin0, $addr, 1) ne substr($bin1, $addr, 1)) {
			push @addrs, $addr;
			$addr++;
		}
	}
	
	return @addrs;
}

sub compute_reloc_addrs {
	my($asm) = @_;
	
	# identify reloc addresses
	my $bin0 = CPU::Z80::Assembler::z80asm("org 0\n".$asm);
	my $bin1 = CPU::Z80::Assembler::z80asm("org 1\n".$asm);
	
	my @addrs;
	for (my $addr = 0; $addr < length($bin0)-1; $addr++) {
		if (substr($bin0, $addr, 1) ne substr($bin1, $addr, 1)) {
			push @addrs, $addr;
			$addr++;
		}
	}
	
	my $reloc_header = reloc_header(@addrs);
	
	return ($bin0, $bin1, $reloc_header, @addrs);
}

# compute reloc header
sub reloc_header {
	my(@addrs) = @_;
	
	my $reloc_data = "";
	my $last_addr = 0;
	my $num_entries = scalar(@addrs);
	while (@addrs) {
		my $addr = shift @addrs;
		my $dist = $addr - $last_addr;
		$last_addr = $addr;
		
		# code distance
		if ($dist > 0 && $dist < 256) {
			$reloc_data .= pack("C", $dist);
		}
		else {
			$reloc_data .= pack("C v", 0, $dist);
		}
	}
	
	my $header = $reloc_routine .
				 pack("v v", $num_entries, length($reloc_data)) .
				 $reloc_data;
	return $header;
}
