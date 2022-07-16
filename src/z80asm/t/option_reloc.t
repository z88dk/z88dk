#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;
use CPU::Z80::Assembler;

# test option -R 

# Test https://github.com/z88dk/z88dk/issues/2045
# z80asm: +zx creates invalid tap file if code has split sections

my $reloc_code = z80asm_file("dev/reloc_code.asm");

#------------------------------------------------------------------------------
# test verbose reloc

# without reloc data
my $asm = "ld hl, 0";
my $bin0 = bytes(0x21, 0, 0);
my $reloc_header = "";
my $reloc_header_size = length($reloc_header);

unlink_testfiles;
spew("${test}.asm", $asm);

capture_ok("z88dk-z80asm -b -v -R ${test}.asm", <<END);
Reading library 'z88dk-z80asm-z80-.lib'
Predefined constant: __CPU_Z80__ = \$0001
Predefined constant: __CPU_ZILOG__ = \$0001
Predefined constant: __FLOAT_GENMATH__ = \$0001
Assembling '${test}.asm' to '${test}.o'
Reading '${test}.asm' = '${test}.asm'
Writing object file '${test}.o'
Module '${test}' size: 3 bytes

Code size: 3 bytes (\$0000 to \$0002)
Creating binary '${test}.bin'
END

check_bin_file("${test}.bin", $reloc_header.$bin0);


# with reloc data
$asm = "start: jp start";
$bin0 = bytes(0xC3, 0, 0);
$reloc_header = reloc_header(1);
$reloc_header_size = length($reloc_header);

unlink_testfiles;
spew("${test}.asm", $asm);

capture_ok("z88dk-z80asm -b -v -R ${test}.asm", <<END);
Reading library 'z88dk-z80asm-z80-.lib'
Predefined constant: __CPU_Z80__ = \$0001
Predefined constant: __CPU_ZILOG__ = \$0001
Predefined constant: __FLOAT_GENMATH__ = \$0001
Assembling '${test}.asm' to '${test}.o'
Reading '${test}.asm' = '${test}.asm'
Writing object file '${test}.o'
Module '${test}' size: 3 bytes

Code size: 3 bytes (\$0000 to \$0002)
Creating binary '${test}.bin'
Relocation header is $reloc_header_size bytes.
END

check_bin_file("${test}.bin", $reloc_header.$bin0);

#------------------------------------------------------------------------------
# test reloc
test_reloc("start: jp start");
test_reloc("start: defw start,start,start");
for (253..257) {
	test_reloc("start: defb 0".(",0" x $_)."\ndefw start,start,start");
}

#------------------------------------------------------------------------------
# test reloc with sections

sub code_asm {
	my($n) = @_;
	return <<END;
	start$n:
		ld bc,string
		ld de,string1
		ld hl,string2
		call start
		call start1
		call start2
END
}

sub data_asm {
	my($n) = @_;
	return <<END;
	string$n:
		defm "hello${n}world"
END
}

#------------------------------------------------------------------------------
# without -R, one module

my $code_addr = 0x1020;
my $data_addr = 0x3040;
$asm = "section code\norg $code_addr\n".code_asm("").
		  "section data\norg $data_addr\n".data_asm("").
		  "section code\n".code_asm("1").
		  "section data\n".data_asm("1").
		  "section code\n".code_asm("2").
		  "section data\n".data_asm("2");

unlink_testfiles;
spew("${test}.asm", $asm);
capture_ok("z88dk-z80asm -b -m -reloc-info ${test}.asm", "");

check_bin_file("${test}.bin", bytes());
check_bin_file("${test}.reloc", words());

check_bin_file("${test}_code.bin", 
		z80asm("org $code_addr\n".
			   "string  equ $data_addr\n".
			   "string1 equ ".($data_addr + 10)."\n".
			   "string2 equ ".($data_addr + 10 + 11)."\n".
			   code_asm("").code_asm("1").code_asm("2")));
			   
check_bin_file("${test}_code.reloc", 
		pack("v*", reloc_addrs(code_asm("").code_asm("1").code_asm("2").
							   "string:\nstring1:\nstring2:\n")));
							   
check_bin_file("${test}_data.bin", 
		z80asm(data_asm("").data_asm("1").data_asm("2")));
		
check_text_file("${test}.map", <<END);
start                           = \$1020 ; addr, local, , ${test}, code, ${test}.asm:3
string                          = \$3040 ; addr, local, , ${test}, data, ${test}.asm:12
string1                         = \$304A ; addr, local, , ${test}, data, ${test}.asm:23
string2                         = \$3055 ; addr, local, , ${test}, data, ${test}.asm:34
start1                          = \$1032 ; addr, local, , ${test}, code, ${test}.asm:15
start2                          = \$1044 ; addr, local, , ${test}, code, ${test}.asm:26
__head                          = \$0000 ; const, public, def, , ,
__tail                          = \$3060 ; const, public, def, , ,
__size                          = \$3060 ; const, public, def, , ,
__code_head                     = \$1020 ; const, public, def, , ,
__code_tail                     = \$1056 ; const, public, def, , ,
__code_size                     = \$0036 ; const, public, def, , ,
__data_head                     = \$3040 ; const, public, def, , ,
__data_tail                     = \$3060 ; const, public, def, , ,
__data_size                     = \$0020 ; const, public, def, , ,
END

#------------------------------------------------------------------------------
# with -R, one module

unlink_testfiles;
spew("${test}.asm", $asm);

# same asm in default section
$asm = code_asm("").code_asm("1").code_asm("2").
		  data_asm("").data_asm("1").data_asm("2");

my @reloc = reloc_addrs($asm);
$reloc_header = reloc_header(@reloc);

capture_ok("z88dk-z80asm -b -m -R ${test}.asm 2>${test}.err", "");

check_text_file("${test}.err", <<END);
${test}.asm: warning: ORG ignored: file ${test}.o, section code
${test}.asm: warning: ORG ignored: file ${test}.o, section data
END

check_bin_file("${test}.bin", $reloc_header.z80asm("org 0\n".$asm));
ok ! -f "${test}.reloc";

ok ! -f "${test}_code.bin";
ok ! -f "${test}_code.reloc";
ok ! -f "${test}_data.bin";
ok ! -f "${test}_data.reloc";

check_text_file("${test}.map", <<END);
start                           = \$005F ; addr, local, , ${test}, code, ${test}.asm:3
string                          = \$0095 ; addr, local, , ${test}, data, ${test}.asm:12
string1                         = \$009F ; addr, local, , ${test}, data, ${test}.asm:23
string2                         = \$00AA ; addr, local, , ${test}, data, ${test}.asm:34
start1                          = \$0071 ; addr, local, , ${test}, code, ${test}.asm:15
start2                          = \$0083 ; addr, local, , ${test}, code, ${test}.asm:26
__head                          = \$005F ; const, public, def, , ,
__tail                          = \$00B5 ; const, public, def, , ,
__size                          = \$00B5 ; const, public, def, , ,
__code_head                     = \$005F ; const, public, def, , ,
__code_tail                     = \$0095 ; const, public, def, , ,
__code_size                     = \$0095 ; const, public, def, , ,
__data_head                     = \$0095 ; const, public, def, , ,
__data_tail                     = \$00B5 ; const, public, def, , ,
__data_size                     = \$007F ; const, public, def, , ,
END

#------------------------------------------------------------------------------
# without -R, several modules

unlink_testfiles;
spew("${test}.asm", 
		"section code\norg $code_addr\n".
		"public start,string\nextern start,start1,start2,string,string1,string2\n".
		code_asm("").
		"section data\norg $data_addr\n".
		data_asm(""));

spew("${test}1.asm", 
		"section code\n".
		"public start1,string1\nextern start,start1,start2,string,string1,string2\n".
		code_asm("1").
		"section data\n".
		data_asm("1"));

spew("${test}2.asm", 
		"section code\n".
		"public start2,string2\nextern start,start1,start2,string,string1,string2\n".
		code_asm("2").
		"section data\n".
		data_asm("2"));

capture_ok("z88dk-z80asm -b -m -reloc-info ${test}.asm ${test}1.asm ${test}2.asm", "");

check_bin_file("${test}.bin", bytes());
check_bin_file("${test}.reloc", words());

check_bin_file("${test}_code.bin", 
		z80asm("org $code_addr\n".
			   "string  equ $data_addr\n".
			   "string1 equ ".($data_addr + 10)."\n".
			   "string2 equ ".($data_addr + 10 + 11)."\n".
			   code_asm("").code_asm("1").code_asm("2")));

check_bin_file("${test}_code.reloc", 
		pack("v*", reloc_addrs(code_asm("").code_asm("1").code_asm("2").
							   "string:\nstring1:\nstring2:\n")));
							   
check_bin_file("${test}_data.bin", 
		z80asm(data_asm("").data_asm("1").data_asm("2")));

check_bin_file("${test}_data.reloc", "");

check_text_file("${test}.map", <<END);
start                           = \$1020 ; addr, public, , ${test}, code, ${test}.asm:5
string                          = \$3040 ; addr, public, , ${test}, data, ${test}.asm:14
start1                          = \$1032 ; addr, public, , ${test}1, code, ${test}1.asm:4
string1                         = \$304A ; addr, public, , ${test}1, data, ${test}1.asm:12
start2                          = \$1044 ; addr, public, , ${test}2, code, ${test}2.asm:4
string2                         = \$3055 ; addr, public, , ${test}2, data, ${test}2.asm:12
__head                          = \$0000 ; const, public, def, , ,
__tail                          = \$3060 ; const, public, def, , ,
__size                          = \$3060 ; const, public, def, , ,
__code_head                     = \$1020 ; const, public, def, , ,
__code_tail                     = \$1056 ; const, public, def, , ,
__code_size                     = \$0036 ; const, public, def, , ,
__data_head                     = \$3040 ; const, public, def, , ,
__data_tail                     = \$3060 ; const, public, def, , ,
__data_size                     = \$0020 ; const, public, def, , ,
END

#------------------------------------------------------------------------------
# with -R, several modules

unlink_testfiles;
spew("${test}.asm", 
		"section code\norg $code_addr\n".
		"public start,string\nextern start,start1,start2,string,string1,string2\n".
		code_asm("").
		"section data\norg $data_addr\n".
		data_asm(""));
		
spew("${test}1.asm", 
		"section code\n".
		"public start1,string1\nextern start,start1,start2,string,string1,string2\n".
		code_asm("1").
		"section data\n".
		data_asm("1"));
		
spew("${test}2.asm", 
		"section code\n".
		"public start2,string2\nextern start,start1,start2,string,string1,string2\n".
		code_asm("2").
		"section data\n".
		data_asm("2"));

$asm = code_asm("").code_asm("1").code_asm("2").
	   data_asm("").data_asm("1").data_asm("2");
	   
@reloc = reloc_addrs($asm);
$reloc_header = reloc_header(@reloc);

capture_ok("z88dk-z80asm -b -m -R ${test}.asm ${test}1.asm ${test}2.asm ".
		   "2>${test}.err", "");

check_text_file("${test}.err", <<ERR);
${test}.asm: warning: ORG ignored: file ${test}.o, section code
${test}.asm: warning: ORG ignored: file ${test}.o, section data
${test}1.asm: warning: ORG ignored: file ${test}1.o, section code
${test}1.asm: warning: ORG ignored: file ${test}1.o, section data
${test}2.asm: warning: ORG ignored: file ${test}2.o, section code
${test}2.asm: warning: ORG ignored: file ${test}2.o, section data
ERR

check_bin_file("${test}.bin", $reloc_header.z80asm("org 0\n".$asm));
ok ! -f "${test}.reloc";

ok ! -f "${test}_code.bin";
ok ! -f "${test}_code.reloc";
ok ! -f "${test}_data.bin";
ok ! -f "${test}_data.reloc";

check_text_file("${test}.map", <<END);
start                           = \$005F ; addr, public, , ${test}, code, ${test}.asm:5
string                          = \$0095 ; addr, public, , ${test}, data, ${test}.asm:14
start1                          = \$0071 ; addr, public, , ${test}1, code, ${test}1.asm:4
string1                         = \$009F ; addr, public, , ${test}1, data, ${test}1.asm:12
start2                          = \$0083 ; addr, public, , ${test}2, code, ${test}2.asm:4
string2                         = \$00AA ; addr, public, , ${test}2, data, ${test}2.asm:12
__head                          = \$005F ; const, public, def, , ,
__tail                          = \$00B5 ; const, public, def, , ,
__size                          = \$00B5 ; const, public, def, , ,
__code_head                     = \$005F ; const, public, def, , ,
__code_tail                     = \$0095 ; const, public, def, , ,
__code_size                     = \$0095 ; const, public, def, , ,
__data_head                     = \$0095 ; const, public, def, , ,
__data_tail                     = \$00B5 ; const, public, def, , ,
__data_size                     = \$007F ; const, public, def, , ,
END

#------------------------------------------------------------------------------
# with -R, several sections with orgs

unlink_testfiles;
spew("${test}.asm", <<END);
	section code1
	org 0x1000
	
start: jp cont
	
	section code2
	org 0x8000
	
cont:  ret
END

my $bin = z80asm(<<END);
	org 0
	
start: jp cont
cont:  ret
END

@reloc = (1);
$reloc_header = reloc_header(@reloc);

capture_ok("z88dk-z80asm -b -m -R ${test}.asm 2>${test}.err", "");

check_text_file("${test}.err", <<ERR);
${test}.asm: warning: ORG ignored: file ${test}.o, section code1
${test}.asm: warning: ORG ignored: file ${test}.o, section code2
ERR

check_bin_file("${test}.bin", $reloc_header.$bin);

ok ! -f "${test}.reloc";

ok ! -f "${test}_code1.bin";
ok ! -f "${test}_code1.reloc";
ok ! -f "${test}_code2.bin";
ok ! -f "${test}_code2.reloc";

check_text_file("${test}.map", <<END);
cont                            = \$0051 ; addr, local, , ${test}, code2, ${test}.asm:9
start                           = \$004E ; addr, local, , ${test}, code1, ${test}.asm:4
__head                          = \$004E ; const, public, def, , ,
__tail                          = \$0052 ; const, public, def, , ,
__size                          = \$0052 ; const, public, def, , ,
__code1_head                    = \$004E ; const, public, def, , ,
__code1_tail                    = \$0051 ; const, public, def, , ,
__code1_size                    = \$0051 ; const, public, def, , ,
__code2_head                    = \$0051 ; const, public, def, , ,
__code2_tail                    = \$0052 ; const, public, def, , ,
__code2_size                    = \$004F ; const, public, def, , ,
END

#------------------------------------------------------------------------------
# without -R, several sections

unlink_testfiles;
spew("${test}.asm", <<END.
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
END
	"section code\n" .code_asm("").
	"section code1\n".code_asm("1").
	"section code2\n".code_asm("2").
	"section data\n" .data_asm("").
	"section data1\n".data_asm("1").
	"section data2\n".data_asm("2"));
	
capture_ok("z88dk-z80asm -b -m -reloc-info ${test}.asm", "");

check_bin_file("${test}.bin", bytes());
check_bin_file("${test}.reloc", words());

check_bin_file("${test}_code.bin", 
		z80asm("org $code_addr\n".
			   "string  equ $data_addr\n".
			   "string1 equ ".($data_addr + 10)."\n".
			   "string2 equ ".($data_addr + 10 + 11)."\n".
			   code_asm("").code_asm("1").code_asm("2")));
			   
check_bin_file("${test}_code.reloc", 
		pack("v*", reloc_addrs(code_asm("").code_asm("1").code_asm("2").
							   "string:\nstring1:\nstring2:\n")));

ok ! -f "${test}_code1.bin";
ok ! -f "${test}_code1.reloc";
ok ! -f "${test}_code2.bin";
ok ! -f "${test}_code2.reloc";

check_bin_file("${test}_data.bin", 
		z80asm(data_asm("").data_asm("1").data_asm("2")));
		
check_bin_file("${test}_data.reloc", "");

ok ! -f "${test}_data1.bin";
ok ! -f "${test}_data1.reloc";
ok ! -f "${test}_data2.bin";
ok ! -f "${test}_data2.reloc";

check_text_file("${test}.map", <<END);
start                           = \$1020 ; addr, local, , ${test}, code, ${test}.asm:12
string                          = \$3040 ; addr, local, , ${test}, data, ${test}.asm:36
string1                         = \$304A ; addr, local, , ${test}, data1, ${test}.asm:39
string2                         = \$3055 ; addr, local, , ${test}, data2, ${test}.asm:42
start1                          = \$1032 ; addr, local, , ${test}, code1, ${test}.asm:20
start2                          = \$1044 ; addr, local, , ${test}, code2, ${test}.asm:28
__head                          = \$0000 ; const, public, def, , ,
__tail                          = \$3060 ; const, public, def, , ,
__size                          = \$3060 ; const, public, def, , ,
__code_head                     = \$1020 ; const, public, def, , ,
__code_tail                     = \$1032 ; const, public, def, , ,
__code_size                     = \$0012 ; const, public, def, , ,
__code1_head                    = \$1032 ; const, public, def, , ,
__code1_tail                    = \$1044 ; const, public, def, , ,
__code1_size                    = \$0012 ; const, public, def, , ,
__code2_head                    = \$1044 ; const, public, def, , ,
__code2_tail                    = \$1056 ; const, public, def, , ,
__code2_size                    = \$0012 ; const, public, def, , ,
__data_head                     = \$3040 ; const, public, def, , ,
__data_tail                     = \$304A ; const, public, def, , ,
__data_size                     = \$000A ; const, public, def, , ,
__data1_head                    = \$304A ; const, public, def, , ,
__data1_tail                    = \$3055 ; const, public, def, , ,
__data1_size                    = \$000B ; const, public, def, , ,
__data2_head                    = \$3055 ; const, public, def, , ,
__data2_tail                    = \$3060 ; const, public, def, , ,
__data2_size                    = \$000B ; const, public, def, , ,
END

unlink_testfiles;
done_testing;


#------------------------------------------------------------------------------
# test with and without -R
sub test_reloc {
	my($asm) = @_;
	local $Test::Builder::Level = $Test::Builder::Level + 1;
	
	my($bin0, $bin1, $reloc_header, @reloc) = compute_reloc_addrs($asm);

	# -R
	for my $options ('-R', '-R -reloc-info') {
		unlink_testfiles;
		spew("${test}.asm", $asm);

		capture_ok("z88dk-z80asm -b $options ${test}.asm", "");
						 
		check_bin_file("${test}.bin", $reloc_header.$bin0);
		ok ! -f "${test}.reloc", "no reloc-info with -R";
	}

	# no -R, no -reloc-info
	unlink_testfiles;
	spew("${test}.asm", "org 1\n".$asm);
	
	capture_ok("z88dk-z80asm -b ${test}.asm", "");
	check_bin_file("${test}.bin", $bin1);
	ok ! -f "${test}.reloc";
	
	# no -R, -reloc-info
	unlink_testfiles;
	spew("${test}.asm", "org 1\n".$asm);
	
	capture_ok("z88dk-z80asm -b -reloc-info ${test}.asm", "");
	check_bin_file("${test}.bin", $bin1);
	check_bin_file("${test}.reloc", pack("v*", @reloc));
}	

sub reloc_addrs {
	my($asm) = @_;
	local $Test::Builder::Level = $Test::Builder::Level + 1;
	
	my($bin0, $bin1, $reloc_header, @addrs) = compute_reloc_addrs($asm);
	return @addrs;
}

# compute reloc addresses and bin files at org 0 and 1
sub compute_reloc_addrs {
	my($asm) = @_;
	local $Test::Builder::Level = $Test::Builder::Level + 1;
	
	# identify reloc addresses
	my $bin0 = z80asm("org 0\n".$asm);
	my $bin1 = z80asm("org 1\n".$asm);
	
	my @addrs;
	for (my $addr = 0; $addr < length($bin0)-1; $addr++) {
		if (substr($bin0, $addr, 1) ne substr($bin1, $addr, 1)) {
			push @addrs, $addr;
			$addr++;
		}
	}

	$reloc_header = reloc_header(@addrs);
	
	return ($bin0, $bin1, $reloc_header, @addrs);
}

# compute reloc header
sub reloc_header {
	my(@addrs) = @_;
	local $Test::Builder::Level = $Test::Builder::Level + 1;
	
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
	
	my $header = $reloc_code .
				 pack("v v", $num_entries, length($reloc_data)) .
				 $reloc_data;
	return $header;
}
