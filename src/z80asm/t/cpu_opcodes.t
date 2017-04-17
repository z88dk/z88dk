#!perl

#------------------------------------------------------------------------------
# Build all the CPU opcodes and test assemble
use Modern::Perl;
use Test::More;
use Path::Tiny;
use Capture::Tiny 'capture';
use Data::HexDump;
use Test::Differences; 

my @CPU = (qw( z80 z180 r2k r3k ));
my @R   = ([B => 0], [C => 1], [D => 2], [E => 3],   [H => 4],   [L => 5], [A => 7]);
my @DD  = ([BC => 0], [DE => 1], [HL => 2], [SP => 3]);
my @DD1 = ([BC => 0], [DE => 1],            [SP => 3]);
my @QQ  = ([BC => 0], [DE => 1], [HL => 2], [AF => 3]);
my @X   = ([IX => 0xDD], [IY => 0xFD]);
my @X8  = ([IXH => 0xDD04], [IXL => 0xDD05], [IYH => 0xFD04], [IYL => 0xFD05]);
my @CC  = ([NZ => 0], [Z => 1], [NC => 2], [C => 3], [PO => 4], [PE => 5], [P => 6], [M => 7]);
my @CC1 = ([NZ => 0], [Z => 1], [NC => 2], [C => 3]);
my @ALU = (["ADD A," => 0], ["ADC A," => 1], [SUB => 2], ["SBC A," => 3], [AND => 4], [XOR => 5], [OR => 6], [CP => 7]);
my @ROT = ([RLC => 0], [RRC => 1], [RL => 2], [RR => 3], [SLA => 4], [SRA => 5], [SLL => 6], [SRL => 7]);
my @BIT = ([BIT => 0x40], [RES => 0x80], [SET => 0xC0]);
my @N   = ([0 => 0], [85 => 0x55], [170 => 0xAA], [255 => 0xFF]);
my @M   = ([0 => 0], [4660 => 0x1234], [52719 => 0xCDEF], [65535 => 0xFFFF]);
my @D   = ([-128 => 0x80], [0 => 0], [127 => 0x7F]);
my @B   = (map {[$_ => $_]} 0..7);
my @RST = (map {[$_*8 => $_]} 0..7);

#------------------------------------------------------------------------------
# globals
my $cpu;		# current cpu
my $filebase;	# current file basename
my $asmf;		# current asm output file handle
my $binf;		# current binary output file handle
my $errf;		# current error output file handle, opcodes that are invalid
my $addr;		# current address

#------------------------------------------------------------------------------
# build opcodes
for (@CPU) {
	$cpu = $_;
	ok 1, $cpu;
	
	$filebase = "t/data/ops_".$cpu;
	path(path($filebase)->dirname)->mkpath;
	
	$addr = 0;
	
	open ($asmf, ">", 	 $filebase.".asm");
	open ($errf, ">", 	 $filebase."_err.asm");
	open ($binf, ">:raw", $filebase.".bmk");
	
	# common
	emit("LD r, r1", 		"0x40 + r * 8 + r1");
	emit("LD r, x8", 		"x8 >> 8", "0x40 + r * 8 + (x8 & 255)");
	
	emit("LD r, n", 		"0x06+r*8", "n");
	emit("LD x8, n", 		"x8 >> 8", "0x06 + (x8 & 255) * 8", "n");
	
	emit("LD r, (HL)", 		"0x46 + r * 8");
	emit("LD r, (x + d)", 	"x", "0x46 + r * 8", "d");

	emit("LD (HL), r", 		"0x70 + r");
	emit("LD (x + d), r", 	"x", "0x70 + r", "d");

	emit("LD (HL), n", 		0x36, "n");
	emit("LD (x + d), n",	"x", 0x36, "d", "n");

	emit("LD A, (BC)", 		0x0A);
	emit("LD A, (DE)", 		0x1A);
	emit("LD A, (m)", 		0x3A, "m & 255", "m >> 8");

	emit("LD (BC), A", 		0x02);
	emit("LD (DE), A", 		0x12);
	emit("LD (m), A", 		0x32, "m & 255", "m >> 8");

	emit("LD I, A", 		0xED, 0x47);
	emit("LD A, I", 		0xED, 0x57);
	emit("LD R, A", 		0xED, 0x4F);
	emit("LD A, R", 		0xED, 0x5F);

	emit("LD IIR, A", 		0xED, 0x47);
	emit("LD A, IIR", 		0xED, 0x57);
	emit("LD EIR, A", 		0xED, 0x4F);
	emit("LD A, EIR", 		0xED, 0x5F);

	emit("LD dd, m", 		"0x01 + dd * 16", "m & 255", "m >> 8");
	emit("LD x, m", 		"x", "0x01 + 2 * 16", "m & 255", "m >> 8");

	emit("LD HL, (m)", 		0x2A, "m & 255", "m >> 8");
	emit("LD x, (m)", 		"x", 0x2A, "m & 255", "m >> 8");

	emit("LD dd1, (m)", 	0xED, "0x4B + dd1 * 16", "m & 255", "m >> 8");

	emit("LD (m), HL", 		0x22, "m & 255", "m >> 8");
	emit("LD (m), x", 		"x", 0x22, "m & 255", "m >> 8");

	emit("LD (m), dd1", 	0xED, "0x43 + dd1 * 16", "m & 255", "m >> 8");

	emit("LD SP, HL",		0xF9);
	emit("LD SP, x",		"x", 0xF9);
	
	emit("PUSH qq",			"0xC5 + qq * 16");
	emit("PUSH x",			"x", "0xC5 + 2 * 16");
	emit("POP qq",			"0xC1 + qq * 16");
	emit("POP x",			"x", "0xC1 + 2 * 16");
	
	emit("EX DE, HL",		0xEB);
	emit("EX AF, AF'",		0x08);
	emit("EXX",				0xD9);
	
	if ($cpu =~ /^z/) {
		emit("EX (SP), HL",	0xE3);
	}
	else {
		emit("EX (SP), HL",	0xED, 0x54);
	}
	emit("EX (SP), x",		"x", 0xE3);
	
	emit("LDI",				0xED, 0xA0);
	emit("LDIR",			0xED, 0xB0);
	emit("LDD",				0xED, 0xA8);
	emit("LDDR",			0xED, 0xB8);
	
	emit("CPI",				0xED, 0xA1);
	emit("CPIR",			0xED, 0xB1);
	emit("CPD",				0xED, 0xA9);
	emit("CPDR",			0xED, 0xB9);
	
	emit("alu r",			"0x80 + alu * 8 + r");
	emit("alu x8",	 		"x8 >> 8", "0x80 + alu * 8 + (x8 & 255)");

	emit("alu n",			"0xC6 + alu * 8", "n");
	emit("alu (HL)",		"0x86 + alu * 8");
	emit("alu (x + d)",		"x", "0x86 + alu * 8", "d");
	
	emit("INC r",			"0x04 + r * 8");
	emit("INC (HL)",		0x34);
	emit("INC (x + d)",		"x", 0x34, "d");
	
	emit("DEC r",			"0x05 + r * 8");
	emit("DEC (HL)",		0x35);
	emit("DEC (x + d)",		"x", 0x35, "d");
	
	emit("DAA",				0x27);
	emit("CPL",				0x2F);
	emit("NEG",				0xED, 0x44);
	emit("CCF",				0x3F);
	emit("SCF",				0x37);
	emit("NOP",				0x00);
	emit("HALT",			0x76);
	emit("DI",				0xF3);
	emit("EI",				0xFB);
	emit("IM 0",			0xED, 0x46);
	emit("IM 1",			0xED, 0x56);
	emit("IM 2",			0xED, 0x5E);
	
	emit("ADD HL, dd",		"0x09 + dd * 16");
	emit("ADD x, dd",		"x", "0x09 + dd * 16");
	emit("ADC HL, dd",		0xED, "0x4A + dd * 16");
	emit("SBC HL, dd",		0xED, "0x42 + dd * 16");
	
	emit("INC dd",			"0x03 + dd * 16");
	emit("INC x",			"x", 0x23);
	emit("DEC dd",			"0x0B + dd * 16");
	emit("DEC x",			"x", 0x2B);
	
	emit("RLCA",			0x07);
	emit("RRCA",			0x0F);
	emit("RLA",				0x17);
	emit("RRA",				0x1F);
	
	emit("rot r",			0xCB, "0x00 + rot * 8 + r");
	emit("rot (HL)",		0xCB, "0x00 + rot * 8 + 6");
	emit("rot (x + d)",		"x", 0xCB, "d", "0x00 + rot * 8 + 6");

	emit("RLD",				0xED, 0x6F);
	emit("RRD",				0xED, 0x67);
	
	emit("bit b, r",		0xCB, "bit + b * 8 + r");
	emit("bit b, (HL)",		0xCB, "bit + b * 8 + 6");
	emit("bit b, (x + d)",	"x", 0xCB, "d", "bit + b * 8 + 6");
	
	emit("JP m",			0xC3, "m & 255", "m >> 8");
	emit("JP cc, m",		"0xC2 + cc * 8", "m & 255", "m >> 8");
	
	emit("JR ASMPC+2",		0x18, 0x00);
	emit("JR cc1, ASMPC+2",	"0x20 + cc1 * 8", 0x00);
	
	emit("JP (HL)",			0xE9);
	emit("JP (x)",			"x", 0xE9);
	
	emit("DJNZ ASMPC+2",	0x10, 0x00);
	
	emit("CALL m",			0xCD, "m & 255", "m >> 8");
	emit("CALL cc, m",		"0xC4 + cc * 8", "m & 255", "m >> 8");
	
	emit("RET",				0xC9);
	emit("RET cc",			"0xC0 + cc * 8");
	emit("RETI",			0xED, 0x4D);
	emit("RETN",			0xED, 0x45);
	
	emit("RST rst",			"0xC7 + rst * 8");
	
	emit("IN A, (n)",		0xDB, "n");
	emit("IN r, (C)",		0xED, "0x40 + r * 8");
	
	emit("INI",				0xED, 0xA2);
	emit("INIR",			0xED, 0xB2);
	emit("IND",				0xED, 0xAA);
	emit("INDR",			0xED, 0xBA);

	emit("OUT (n), A",		0xD3, "n");
	emit("OUT (C), r",		0xED, "0x41 + r * 8");
	
	emit("OUTI",			0xED, 0xA3);
	emit("OTIR",			0xED, 0xB3);
	emit("OUTD",			0xED, 0xAB);
	emit("OTDR",			0xED, 0xBB);

	# Z180
	emit("MLT dd",			0xED, "0x4C + dd * 16");

	emit("TST r",			0xED, "0x04 + r * 8");
	emit("TST n",			0xED, 0x64, "n");
	emit("TST (HL)",		0xED, 0x34);
	
	emit("IN0 r, (n)",		0xED, "0x00 + r * 8", "n");
	emit("OUT0 (n), r",		0xED, "0x01 + r * 8", "n");
	
	emit("OTDM",			0xED, 0x8B);
	emit("OTDMR",			0xED, 0x9B);
	emit("OTIM",			0xED, 0x83);
	emit("OTIMR",			0xED, 0x93);

	emit("TSTIO n",			0xED, 0x74, "n");
	emit("SLP",				0xED, 0x76);

	# Rabbit RCM2000
	emit("ADD SP, d",		0x27, "d");
	emit("ALTD",			0x76);			# TODO: add all ALTD combinations
	
	emit("AND HL, DE",		0xDC);
	emit("AND x, DE",		"x", 0xDC);
	
	emit("BOOL HL",			0xCC);
	emit("BOOL x",			"x", 0xCC);
	
	emit("EX DE', HL",		0xE3);
	emit("EX DE, HL'",		0x76, 0xEB);
	emit("EX DE', HL'",		0x76, 0xE3);

	emit("IOE",				0xDB);
	emit("IOI",				0xD3);
	
	# Rabbit 3000
	emit("IDET",			0x5B);
	
	close $asmf;
	close $binf;
	close $errf;
	
	test_asm();
}

done_testing;

sub emit {
	my($opcode, @bytes) = @_;

	# expand opcodes
	if ($opcode =~ /\b(r\d*)\b/) {
		return expand_emit($1, \@R, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(dd)\b/) {
		return expand_emit($1, \@DD, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(dd1)\b/) {
		return expand_emit($1, \@DD1, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(qq)\b/) {
		return expand_emit($1, \@QQ, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(x)\b/) {
		return expand_emit($1, \@X, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(x8)\b/) {
		return expand_emit($1, \@X8, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(cc)\b/) {
		return expand_emit($1, \@CC, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(cc1)\b/) {
		return expand_emit($1, \@CC1, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(alu)\b/) {
		return expand_emit($1, \@ALU, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(rot)\b/) {
		return expand_emit($1, \@ROT, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(bit)\b/) {
		return expand_emit($1, \@BIT, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(n)\b/) {
		return expand_emit($1, \@N, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(m)\b/) {
		return expand_emit($1, \@M, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(d)\b/) {
		return expand_emit($1, \@D, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(b)\b/) {
		return expand_emit($1, \@B, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(rst)\b/) {
		return expand_emit($1, \@RST, $opcode, @bytes);
	}
	
	$opcode = replace_index($opcode);
	
	# emit
	my $asm_line = sprintf(" %-23s;; %04X: ", $opcode, $addr);
	my $bin_line = '';
	for (@bytes) {
		my $byte = eval($_); $@ and die $@;
		$asm_line .= sprintf(" %02X", $byte);
		$bin_line .= chr($byte);
	}
	
	if (($asm_line =~ /\b ( I[XY][HL] ) \b/x && $cpu ne 'z80') ||
	    ($asm_line =~ /\b ( EIR | IIR |
							ADD \s+ SP | AND \s+ (HL|IX|IY) | 
							ALTD |
							BOOL |
							IOE | IOI ) \b |
						\b ( DE\' | HL\' ) /x && $cpu =~ /^z/) ||
	    ($asm_line =~ /\b ( MLT | TST | 
							IN0 | OUT0 | 
							OTDM | OTDMR | 
							TSTIO | 
							OTIM | OTIMR | 
							SLP ) \b/x && $cpu eq 'z80') ||
	    ($asm_line =~ /\b ( I | R | 
							DAA | MLT \s+ SP | RRD | RLD | 
							HALT | DI | EI | IM \s+ 0 | IM \s+ 1 | IM \s+ 2 | RETN |
							OUT | IN | OUT0 | IN0 | SLP | 
							INI | IND | INIR | INDR | 
							OUTI | OUTD | OTIR | OTDR | 
							OTDM | OTDMR | OTIM | OTIMR |
							TSTIO |
							CPI | CPIR | CPD | CPDR |
							RST \s+ 0 | RST \s+ 8 | RST \s+ 48 |
							CALL \s+ (NZ|Z|NC|C|PO|PE|P|M) \b |
							SLL ) \b/x && $cpu =~ /^r/) ||
		($asm_line =~ /\b ( IDET ) \b/x && $cpu ne 'r3k')
	) {
		say $errf $asm_line;
	}
	else {
		say $asmf $asm_line;
		print $binf $bin_line;
		$addr += length($bin_line);
	}
}

sub replace_index {
	local($_) = @_;
	/IX[HL]/ and s/\b([HL])\b/IX$1/g;
	/IY[HL]/ and s/\b([HL])\b/IY$1/g;
	/IX/     and s/\bHL\b/IX/g;
	/IY/     and s/\bHL\b/IY/g;
	return $_;
}

sub expand_emit {
	my($replace, $list, $opcode, @bytes) = @_;
	
	for (@$list) {
		my($text, $id) = @$_;
		
		(my $opcode_inst = $opcode) =~ s/\b$replace\b/$text/g;
		my @bytes_inst = @bytes;
		for (@bytes_inst) {
			s/\b$replace\b/$id/g;
		}
		
		emit($opcode_inst, @bytes_inst);
	}
}

sub test_asm {
	my $opt;
	if ($cpu eq 'z80') {		$opt = '';	}
	elsif ($cpu eq 'z180') {	$opt = '--cpu=z180'	}
	elsif ($cpu eq 'r2k') {		$opt = '--cpu=r2k'	}
	elsif ($cpu eq 'r3k') {		$opt = '--cpu=r3k'	}
	else {						die "cpu $cpu unknown\n";	}
	
	# build OK
	my $cmd = "./z80asm $opt -l -b --no-emul $filebase";
	ok system($cmd)==0, $cmd;
	
	my $bin = path("$filebase.bin")->slurp_raw;
	my $bmk = path("$filebase.bmk")->slurp_raw;
	$cmd = "diff $filebase.bin $filebase.bmk";
	ok $bin eq $bmk, $cmd;
	
	if ($bin eq $bmk) {
		unlink "$filebase.lis";
		unlink "$filebase.o";
		unlink "$filebase.bin";
		unlink "$filebase.err";
	}
	else {
		my $bin_dump = HexDump($bin);
		my $bmk_dump = HexDump($bmk);
		eq_or_diff $bin_dump, $bmk_dump;
	}
	
	# build failure for invalid opcodes
	my $num_errors = scalar(path($filebase."_err.asm")->lines);
	if ($num_errors > 0) {
		$cmd = "./z80asm $opt -l -b --no-emul ".$filebase."_err";

		my($stdout, $stderr, $exit) = capture {	system($cmd); };
		is $stdout, "", "output of $cmd";
		ok $exit != 0, "exit of $cmd";
		
		# test that all lines have been signalled as error
		my @lines_error;
		for (split(/\n/, $stderr)) {
			if (/Error at file .*? line (\d+)/) {
				$lines_error[$1] = 1;
			}
			elsif (/\d+ errors occurred during assembly/) {
			}
			else {
				diag $_;
				ok 0, "cannot parse error line";
			}
		}
		my $ok = 1;
		for (1 .. $num_errors) {
			if (!defined $lines_error[$_]) {
				ok 0, "expected error on line $_";
				$ok = 0;
			}
		}
		ok $ok, "errors of $cmd";
		if ($ok) {
			unlink $filebase."_err.err"
		}
	}
}
