#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2015
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Test options

use strict;
use warnings;
use Test::Differences; 
use Test::More;
require 't/test_utils.pl';

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

t_reloc("start: jp start", 
		pack("C*", 0xC3, 0, 0),
		1);
t_reloc("start: defw start,start,start", 
		pack("v*", 0, 0, 0),
		0, 2, 4);
t_reloc("start: defs 255, 0\ndefw start,start,start", 
		pack("C*", (0) x 255, 0,0, 0,0, 0,0),
		255, 257, 259);
t_reloc("start: defs 256, 0\ndefw start,start,start", 
		pack("C*", (0) x 256, 0,0, 0,0, 0,0),
		256, 258, 260);

# test reloc with sections
my $asm = <<'...';
	section code
	org 0x1080
	start:
		ld hl, string	; 21 80 20
	loop:
		ld a,(hl)		; 7E
		inc hl			; 23
		and a			; A7
		jp nz, loop		; C2 83 10
		jp start		; C3 80 10
		
	section data
	org 0x2080
	string: defb "hello", 0
			defw start, loop, string	; 80 10 83 10 80 20
...
my @code_reloc = (1, 7, 10);
my @data_reloc = (6, 8, 10);
my @reloc; 
push @reloc, @code_reloc;
push @reloc, map {$_ + 12} @data_reloc;

# without --relocatable
unlink_testfiles();
write_file("test.asm", $asm);
t_z80asm_capture("-b test.asm", "", "", 0);

t_binary(read_binfile("test.bin"), "");
t_binary(read_binfile("test.reloc"), "");

t_binary(read_binfile("test_code.bin"), 
	pack("C*", 
		0x21, 0x80, 0x20,
		0x7E,
		0x23,
		0xA7,
		0xC2, 0x83, 0x10,
		0xC3, 0x80, 0x10));
t_binary(read_binfile("test_code.reloc"), pack("v*", @code_reloc));

t_binary(read_binfile("test_data.bin"), 
	"hello\0".
	pack("C*", 
		0x80, 0x10,
		0x83, 0x10,
		0x80, 0x20));
t_binary(read_binfile("test_data.reloc"), pack("v*", @data_reloc));

eq_or_diff scalar(read_file("test.map")), <<'...', "mapfile contents";
ASMHEAD                         = 0000, G: 
ASMHEAD_code                    = 1080, G: 
ASMHEAD_data                    = 2080, G: 
ASMSIZE                         = 208C, G: 
ASMSIZE_code                    = 000C, G: 
ASMSIZE_data                    = 000C, G: 
ASMTAIL                         = 208C, G: 
ASMTAIL_code                    = 108C, G: 
ASMTAIL_data                    = 208C, G: 
loop                            = 1083, L: test
start                           = 1080, L: test
string                          = 2080, L: test


ASMHEAD                         = 0000, G: 
ASMSIZE_code                    = 000C, G: 
ASMSIZE_data                    = 000C, G: 
ASMHEAD_code                    = 1080, G: 
start                           = 1080, L: test
loop                            = 1083, L: test
ASMTAIL_code                    = 108C, G: 
ASMHEAD_data                    = 2080, G: 
string                          = 2080, L: test
ASMSIZE                         = 208C, G: 
ASMTAIL                         = 208C, G: 
ASMTAIL_data                    = 208C, G: 
...

# with --relocatable
my $reloc_header = reloc_header(@reloc);

unlink_testfiles();
write_file("test.asm", $asm);
t_z80asm_capture("-b --relocatable test.asm", 
	"Relocation header is ".length($reloc_header)." bytes.\n", 
	"Warning at module 'test': --relocatable ignores ORG at file 'test.obj', section 'code'\n".
	"Warning at module 'test': --relocatable ignores ORG at file 'test.obj', section 'data'\n",
	0);
ok ! -f "test.reloc";
ok ! -f "test_code.reloc";
ok ! -f "test_data.reloc";

t_binary(read_binfile("test.bin"), 
	$reloc_header.
	pack("C*", 
		0x21, 0x0C, 0x00,
		0x7E,
		0x23,
		0xA7,
		0xC2, 0x03, 0x00,
		0xC3, 0x00, 0x00).
	"hello\0".
	pack("C*", 
		0x00, 0x00,
		0x03, 0x00,
		0x0C, 0x00));

eq_or_diff scalar(read_file("test.map")), <<'...', "mapfile contents";
ASMHEAD                         = 0053, G: 
ASMHEAD_code                    = 0053, G: 
ASMHEAD_data                    = 005F, G: 
ASMSIZE                         = 006B, G: 
ASMSIZE_code                    = 005F, G: 
ASMSIZE_data                    = 005F, G: 
ASMTAIL                         = 006B, G: 
ASMTAIL_code                    = 005F, G: 
ASMTAIL_data                    = 006B, G: 
loop                            = 0056, L: test
start                           = 0053, L: test
string                          = 005F, L: test


ASMHEAD                         = 0053, G: 
ASMHEAD_code                    = 0053, G: 
start                           = 0053, L: test
loop                            = 0056, L: test
ASMHEAD_data                    = 005F, G: 
ASMSIZE_code                    = 005F, G: 
ASMSIZE_data                    = 005F, G: 
ASMTAIL_code                    = 005F, G: 
string                          = 005F, L: test
ASMSIZE                         = 006B, G: 
ASMTAIL                         = 006B, G: 
ASMTAIL_data                    = 006B, G: 
...

unlink_testfiles();
done_testing();

#------------------------------------------------------------------------------
# compute reloc header for the given list of addresses
#------------------------------------------------------------------------------
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

#------------------------------------------------------------------------------
# test with and without -R
#------------------------------------------------------------------------------
sub t_reloc {
	my($asm, $bin, @reloc) = @_;
	
	ok 1, "line ".(caller)[2];
	
	my $reloc_header = reloc_header(@reloc);
	
	# -R
	for my $options ('-R', '--relocatable') {
		unlink_testfiles();
		write_file("test.asm", $asm);
		
		t_z80asm_capture("-b $options test.asm", 
						 "Relocation header is ".length($reloc_header)." bytes.\n", "", 0);
						 
		t_binary(read_binfile("test.bin"), $reloc_header.$bin);
		ok ! -f "test.reloc";
	}

	# not -R
	unlink_testfiles();
	write_file("test.asm", $asm);
	
	t_z80asm_capture("-b test.asm", "", "", 0);
	t_binary(read_file("test.bin", binmode => ':raw'), $bin);
	t_binary(read_binfile("test.reloc"), pack("v*", @reloc));
}
