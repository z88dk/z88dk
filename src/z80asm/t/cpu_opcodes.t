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
my @DD2 = ([BC => 0], [DE => 1], [HL => 2]           );
my @QQ  = ([BC => 0], [DE => 1], [HL => 2], [AF => 3]);
my @X   = ([IX => 0xDD], [IY => 0xFD]);
my @X8  = ([IXH => 0xDD04], [IXL => 0xDD05], [IYH => 0xFD04], [IYL => 0xFD05]);
my @CC  = ([NZ => 0], [Z => 1], [NC => 2], [C => 3], [PO => 4], [PE => 5], [P => 6], [M => 7]);
my @CCR = (                                          [LZ => 4], [LO => 5]                    );
my @CC1 = ([NZ => 0], [Z => 1], [NC => 2], [C => 3]);
my @ALU = (["ADD A," => 0], ["ADC A," => 1], [SUB => 2], ["SBC A," => 3], [AND => 4], [XOR => 5], [OR => 6], [CP => 7]);
my @ROT = ([RLC => 0], [RRC => 1], [RL => 2], [RR => 3], [SLA => 4], [SRA => 5],             [SRL => 7]);
my @ROTZ= (                                                                      [SLL => 6]            );
my @BIT = ([BIT => 0x40], [RES => 0x80], [SET => 0xC0]);
my @N   = ([0 => 0], [85 => 0x55], [170 => 0xAA], [255 => 0xFF]);
my @M   = ([0 => 0], [4660 => 0x1234], [52719 => 0xCDEF], [65535 => 0xFFFF]);
my @D   = ([-128 => 0x80], [0 => 0], [127 => 0x7F]);
my @B   = (map {[$_ => $_]} 0..7);
my @RST  = (                          [0x10 => 2], [0x18 => 3], [0x20 => 4], [0x28 => 5],              [0x38 => 7]);
my @RSTZ = ([0x00 => 0], [0x08 => 1],                                                     [0x30 => 6]             );

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
	
	# cpu flags
	my $ALL		= 1;
	my $Z80 	= $cpu eq 'z80';
	my $Z180 	= $cpu eq 'z180';
	my $R2K		= $cpu eq 'r2k';
	my $R3K		= $cpu eq 'r3k';
	my $NOT_Z80	= ! $Z80;
	my $ZILOG	= $Z80 || $Z180;
	my $RABBIT	= $R2K || $R3K;
	
	# 16-bit load group
	emit($ALL,		"LD dd, m", 		"0x01 + dd * 16", "m & 255", "m >> 8");
	emit($ALL,		"LD x, m", 			"x", "0x01 + 2 * 16", "m & 255", "m >> 8");
	
	emit($ALL,		"LD HL, (m)", 		0x2A, "m & 255", "m >> 8");
	emit($ALL,		"LD x, (m)", 		"x", 0x2A, "m & 255", "m >> 8");

	emit($ALL,		"LD dd1, (m)", 		0xED, "0x4B + dd1 * 16", "m & 255", "m >> 8");

	emit($ALL,		"LD (m), HL", 		0x22, "m & 255", "m >> 8");
	emit($ALL,		"LD (m), x", 		"x", 0x22, "m & 255", "m >> 8");

	emit($ALL,		"LD (m), dd1", 		0xED, "0x43 + dd1 * 16", "m & 255", "m >> 8");

	emit($ALL,		"LD SP, HL",		0xF9);
	emit($ALL,		"LD SP, x",			"x", 0xF9);
	
	emit($ALL,		"PUSH qq",			"0xC5 + qq * 16");
	emit($ALL,		"PUSH x",			"x", "0xC5 + 2 * 16");
	emit($ALL,		"POP qq",			"0xC1 + qq * 16");
	emit($ALL,		"POP x",			"x", "0xC1 + 2 * 16");
	
	emit($RABBIT,	"LD (HL + d), HL",	0xDD, 0xF4, "d");
	emit($RABBIT,	"LD (ix + d), HL",	      0xF4, "d");		# Note: lower case ix, iy to avoid replacement in replace_index()
	emit($RABBIT,	"LD (iy + d), HL",	0xFD, 0xF4, "d");
	
	emit($RABBIT, 	"LD (SP + n), HL",	0xD4, "n");
	emit($RABBIT, 	"LD (SP + n), x",	"x", 0xD4, "n");
	
	# Exchange Group
	emit($ALL,		"EX DE, HL",		0xEB);
	emit($ALL,		"EX AF, AF'",		0x08);
	emit($ALL,		"EXX",				0xD9);
	
	if ($ZILOG) {
		emit($ALL,	"EX (SP), HL",		0xE3);
	}
	else {
		emit($ALL,	"EX (SP), HL",		0xED, 0x54);
	}

	emit($ALL,		"EX (SP), x",		"x", 0xE3);
	
	emit($RABBIT,	"EX DE', HL",		0xE3);
	emit($RABBIT,	"EX DE, HL'",		0x76, 0xEB);
	emit($RABBIT,	"EX DE', HL'",		0x76, 0xE3);

	
	# Block Transfer Group
	emit($ALL,		"LDI",				0xED, 0xA0);
	emit($ALL,		"LDIR",				0xED, 0xB0);
	emit($ALL,		"LDD",				0xED, 0xA8);
	emit($ALL,		"LDDR",				0xED, 0xB8);
	

	# Search Group
	emit($ZILOG,	"CPI",				0xED, 0xA1);
	emit($ZILOG,	"CPIR",				0xED, 0xB1);
	emit($ZILOG,	"CPD",				0xED, 0xA9);
	emit($ZILOG,	"CPDR",				0xED, 0xB9);
	
	
	# 8-Bit Arithmetic Group
	emit($ALL,		"alu r",			"0x80 + alu * 8 + r");
	emit($Z80,		"alu x8",	 		"x8 >> 8", "0x80 + alu * 8 + (x8 & 255)");
	
	emit($ALL,		"alu n",			"0xC6 + alu * 8", "n");
	emit($ALL,		"alu (HL)",			"0x86 + alu * 8");
	emit($ALL,		"alu (x + d)",		"x", "0x86 + alu * 8", "d");
	
	emit($ALL,		"INC r",			"0x04 + r * 8");
	emit($ALL,		"INC (HL)",			0x34);
	emit($ALL,		"INC (x + d)",		"x", 0x34, "d");
	
	emit($ALL,		"DEC r",			"0x05 + r * 8");
	emit($ALL,		"DEC (HL)",			0x35);
	emit($ALL,		"DEC (x + d)",		"x", 0x35, "d");
	
	emit($NOT_Z80,	"TST r",			0xED, "0x04 + r * 8");
	emit($NOT_Z80,	"TST n",			0xED, 0x64, "n");
	emit($NOT_Z80,	"TST (HL)",			0xED, 0x34);
	
	
	# General-Purpose Arithmetic Group
	emit($ZILOG,	"DAA",				0x27);
	emit($ZILOG,	"RLD",				0xED, 0x6F);
	emit($ZILOG,	"RRD",				0xED, 0x67);
	
	emit($ALL,		"CPL",				0x2F);
	emit($ALL,		"NEG",				0xED, 0x44);
	emit($ALL,		"CCF",				0x3F);
	emit($ALL,		"SCF",				0x37);


	# CPU Control Group
	emit($ALL,		"NOP",				0x00);
	emit($ZILOG,	"HALT",				0x76);
	emit($Z180,		"SLP",				0xED, 0x76);
	
	emit($RABBIT,	"ALTD",				0x76);			# TODO: add all ALTD combinations

	emit($RABBIT,	"LD A, XPC",		0xED, 0x77);
	emit($RABBIT,	"LD XPC, A",		0xED, 0x67);
	

	# 16-Bit Arithmetic Group
	emit($ALL,		"ADD HL, dd",		"0x09 + dd * 16");
	emit($ALL,		"ADD x, dd",		"x", "0x09 + dd * 16");

	emit($RABBIT,	"ADD SP, d",		0x27, "d");

	emit($ALL,		"ADC HL, dd",		0xED, "0x4A + dd * 16");

	emit($ALL,		"SBC HL, dd",		0xED, "0x42 + dd * 16");
	
	emit($RABBIT,	"AND HL, DE",		0xDC);
	emit($RABBIT,	"AND x, DE",		"x", 0xDC);
	
	emit($RABBIT,	"BOOL HL",			0xCC);
	emit($RABBIT,	"BOOL x",			"x", 0xCC);
	
	emit($ALL,		"INC dd",			"0x03 + dd * 16");
	emit($ALL,		"INC x",			"x", 0x23);
	emit($ALL,		"DEC dd",			"0x0B + dd * 16");
	emit($ALL,		"DEC x",			"x", 0x2B);

	emit($NOT_Z80,	"MLT dd2",			0xED, "0x4C + dd2 * 16");
	emit($Z180,		"MLT SP",			0xED, "0x4C + 3   * 16");

	
	# Rotate and Shift Group
	emit($ALL,		"RLCA",				0x07);
	emit($ALL,		"RRCA",				0x0F);
	emit($ALL,		"RLA",				0x17);
	emit($ALL,		"RRA",				0x1F);
	
	emit($ALL,		"rot r",			0xCB, "0x00 + rot  * 8 + r");
	emit($ZILOG,	"rotz r",			0xCB, "0x00 + rotz * 8 + r");
	
	emit($ALL,		"rot (HL)",			0xCB, "0x00 + rot  * 8 + 6");
	emit($ZILOG,	"rotz (HL)",		0xCB, "0x00 + rotz * 8 + 6");
	
	emit($ALL,		"rot (x + d)",		"x", 0xCB, "d", "0x00 + rot  * 8 + 6");
	emit($ZILOG,	"rotz (x + d)",		"x", 0xCB, "d", "0x00 + rotz * 8 + 6");

	
	# Bit Set, Reset, and Test Group
	emit($ALL,		"bit b, r",			0xCB, "bit + b * 8 + r");
	emit($ALL,		"bit b, (HL)",		0xCB, "bit + b * 8 + 6");
	emit($ALL,		"bit b, (x + d)",	"x", 0xCB, "d", "bit + b * 8 + 6");

	
	# Jump Group
	emit($ALL,		"JP m",				0xC3, "m & 255", "m >> 8");

	emit($ALL,		"JP cc, m",			"0xC2 + cc  * 8", "m & 255", "m >> 8");
	emit($RABBIT,	"JP ccr, m",		"0xC2 + ccr * 8", "m & 255", "m >> 8");
	
	emit($ALL,		"JR ASMPC+2",		0x18, 0x00);
	emit($ALL,		"JR cc1, ASMPC+2",	"0x20 + cc1 * 8", 0x00);
	
	emit($ALL,		"JP (HL)",			0xE9);
	emit($ALL,		"JP (x)",			"x", 0xE9);
	
	emit($ALL,		"DJNZ ASMPC+2",		0x10, 0x00);

	
	# Call and Return Group
	emit($ALL,		"CALL m",			0xCD, "m & 255", "m >> 8");
	emit($ZILOG,	"CALL cc, m",		"0xC4 + cc * 8", "m & 255", "m >> 8");
	
	emit($ALL,		"RET",				0xC9);
	
	emit($ALL,		"RET cc",			"0xC0 + cc  * 8");
	emit($RABBIT,	"RET ccr",			"0xC0 + ccr * 8");

	emit($ALL,		"RST rst",			"0xC7 + rst  * 8");
	emit($ZILOG,	"RST rstz",			"0xC7 + rstz * 8");

	# TODO: support LCALL - convert label to XPC:ADDR, where 0xE000 <= ADDR <= 0xFFFF
	
	
	# Input and Output Group
	emit($ZILOG,	"IN A, (n)",		0xDB, "n");
	emit($ZILOG,	"IN r, (C)",		0xED, "0x40 + r * 8");
	
	emit($ZILOG,	"INI",				0xED, 0xA2);
	emit($ZILOG,	"INIR",				0xED, 0xB2);
	emit($ZILOG,	"IND",				0xED, 0xAA);
	emit($ZILOG,	"INDR",				0xED, 0xBA);

	emit($ZILOG,	"OUT (n), A",		0xD3, "n");
	emit($ZILOG,	"OUT (C), r",		0xED, "0x41 + r * 8");
	
	emit($ZILOG,	"OUTI",				0xED, 0xA3);
	emit($ZILOG,	"OTIR",				0xED, 0xB3);
	emit($ZILOG,	"OUTD",				0xED, 0xAB);
	emit($ZILOG,	"OTDR",				0xED, 0xBB);

	emit($Z180,		"IN0 r, (n)",		0xED, "0x00 + r * 8", "n");
	emit($Z180,		"OUT0 (n), r",		0xED, "0x01 + r * 8", "n");
	
	emit($Z180,		"OTDM",				0xED, 0x8B);
	emit($Z180,		"OTDMR",			0xED, 0x9B);
	emit($Z180,		"OTIM",				0xED, 0x83);
	emit($Z180,		"OTIMR",			0xED, 0x93);

	emit($Z180,		"TSTIO n",			0xED, 0x74, "n");

	emit($RABBIT,	"IOE",				0xDB);
	emit($RABBIT,	"IOI",				0xD3);

	
	# Interrupt control group
	emit($ZILOG,	"DI",				0xF3);
	emit($ZILOG,	"EI",				0xFB);
	emit($ZILOG,	"IM 0",				0xED, 0x46);
	emit($ZILOG,	"IM 1",				0xED, 0x56);
	emit($ZILOG,	"IM 2",				0xED, 0x5E);
	
	emit($RABBIT,	"IPSET 0",			0xED, 0x46);
	emit($RABBIT,	"IPSET 1",			0xED, 0x56);
	emit($RABBIT,	"IPSET 2",			0xED, 0x4E);
	emit($RABBIT,	"IPSET 3",			0xED, 0x5E);

	emit($RABBIT,	"IPRES",			0xED, 0x5D);

	emit($ZILOG,	"LD I, A", 			0xED, 0x47);
	emit($ZILOG,	"LD A, I", 			0xED, 0x57);
	emit($ZILOG,	"LD R, A", 			0xED, 0x4F);
	emit($ZILOG,	"LD A, R", 			0xED, 0x5F);

	emit($RABBIT,	"LD IIR, A", 		0xED, 0x47);
	emit($RABBIT,	"LD A, IIR", 		0xED, 0x57);
	emit($RABBIT,	"LD EIR, A", 		0xED, 0x4F);
	emit($RABBIT,	"LD A, EIR", 		0xED, 0x5F);

	emit($ALL,		"RETI",				0xED, 0x4D);
	emit($ZILOG,	"RETN",				0xED, 0x45);

	emit($R3K,		"IDET",				0x5B);

	my $in_file = $0; $in_file =~ s/\.t$/.in/i or die;
	parse($cpu, path($in_file)->lines);
	
	close $asmf;
	close $binf;
	close $errf;
	
	test_asm();
}

done_testing;

sub emit {
	my($exists, $opcode, @bytes) = @_;

	# expand opcodes
	if ($opcode =~ /\b(r\d*)\b/) {
		return expand_emit($exists, $1, \@R, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(dd)\b/) {
		return expand_emit($exists, $1, \@DD, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(dd1)\b/) {
		return expand_emit($exists, $1, \@DD1, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(dd2)\b/) {
		return expand_emit($exists, $1, \@DD2, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(qq)\b/) {
		return expand_emit($exists, $1, \@QQ, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(x)\b/) {
		return expand_emit($exists, $1, \@X, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(x8)\b/) {
		return expand_emit($exists, $1, \@X8, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(cc)\b/) {
		return expand_emit($exists, $1, \@CC, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(ccr)\b/) {
		return expand_emit($exists, $1, \@CCR, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(cc1)\b/) {
		return expand_emit($exists, $1, \@CC1, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(alu)\b/) {
		return expand_emit($exists, $1, \@ALU, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(rot)\b/) {
		return expand_emit($exists, $1, \@ROT, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(rotz)\b/) {
		return expand_emit($exists, $1, \@ROTZ, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(bit)\b/) {
		return expand_emit($exists, $1, \@BIT, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(n)\b/) {
		return expand_emit($exists, $1, \@N, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(m)\b/) {
		return expand_emit($exists, $1, \@M, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(d)\b/) {
		return expand_emit($exists, $1, \@D, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(b)\b/) {
		return expand_emit($exists, $1, \@B, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(rst)\b/) {
		return expand_emit($exists, $1, \@RST, $opcode, @bytes);
	}
	elsif ($opcode =~ /\b(rstz)\b/) {
		return expand_emit($exists, $1, \@RSTZ, $opcode, @bytes);
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
	
	if (!$exists) {
		say $errf $asm_line;
	}
	else {
		say $asmf $asm_line;
		print $binf $bin_line;
		$addr += length($bin_line);
	}
}

sub parse {
	my($cpu, @lines) = @_;
	
	# read each line
	for (@lines) {
		for (split(/\n/, $_)) {
			next if /^\s*\#/;
			next if /^\s*\;/;
			next if /^\s*$/;
			s/^\s+//;
			s/\s+$//;
			s/\s+/ /g;
			
			# check if cpu has this opcode
			my $exists = 1;
			if (/^\[(.*?)\]\s*/) {
				my($cpus, $rest) = ($1, $');
				$_ = $rest;
				$exists = check_cpus($cpu, split(' ', $cpus));
			}
			
			# get opcode and bytes
			my($opcode, $bytes) = split(/\s*=>\s*/, $_);
			emit_line($exists, $opcode, $bytes);
		}
	}
}

sub check_cpus {
	my($cpu, @cpus) = @_;
	for (@cpus) {
		return 1 if /$cpu/i;
		return 1 if /zilog/i && $cpu =~ /^z/;
		return 1 if /rabbit/i && $cpu =~ /^r/;
		return 1 if /not_z80/i && $cpu !~ /z80/i;
	}
	return 0;
}

sub emit_line {
	my($exists, $opcode, $bytes, $var) = @_;
	$var ||= 1;		# start with $1
	
	# expand $var
	if ($opcode =~ /\{(.*?)\}/) {
		my($before, $list, $after) = ($`, $1, $');
		my @list = split(' ', $list);
		for (0 .. $#list) {
			my($id, $text) = ($_, $list[$_]);
			next if $text eq '.';				# use a DOT to skip items
			
			my $opcode_copy = $before . $text . $after;
			my $bytes_copy = $bytes; $bytes_copy =~ s/\$$var/ sprintf("%X", $id) /ge;
			
			emit_line($exists, $opcode_copy, $bytes_copy, $var+1);
		}
		return;
	}
	
	# expand N, MN, D
	if ($opcode =~ /\b(MN)\b/) { 
		return expand_values($exists, $opcode, $bytes, $1, 0, 0x0123, 0x4567, 0x89AB, 0xCDEF, 0xFFFF);
	} 
	elsif ($opcode =~ /\b(N)\b/) { 
		return expand_values($exists, $opcode, $bytes, $1, 0, 0x55, 0xAA, 0xFF);
	} 
	elsif ($opcode =~ /\b(D)\b/) { 
		return expand_values($exists, $opcode, $bytes, $1, -128, 0, 127);
	} 
	else { 
	} 

	# compute bytes
	$bytes =~ s/([0-9A-F]+)/0x$1/g;		# all numbers in hex
	my @bytes = split(/\s*,\s*/, $bytes);
	
	# emit
	my $asm_line = sprintf(" %-23s;; %04X: ", $opcode, $addr);
	my $bin_line = '';
	for (@bytes) {
		my $byte = eval($_); $@ and die $@;
		$asm_line .= sprintf(" %02X", $byte);
		$bin_line .= chr($byte);
	}
	
	if (!$exists) {
		say $errf $asm_line;
	}
	else {
		say $asmf $asm_line;
		print $binf $bin_line;
		$addr += length($bin_line);
	}
}

sub expand_values {
	my($exists, $opcode, $bytes, $var, @values) = @_;
	for (@values) {
		my $opcode_copy = $opcode; $opcode_copy =~ s/\b$var\b/$_/g;
		my $bytes_copy = $bytes; 
		$bytes_copy =~ s/\b$var\b/ sprintf("%X", $_ & 255) /ge;
		if ($var eq 'MN') {
			$bytes_copy =~ s/\bM\b/ sprintf("%X", ($_ >>  8) & 255) /ge;
			$bytes_copy =~ s/\bN\b/ sprintf("%X",         $_ & 255) /ge;
		}

		emit_line($exists, $opcode_copy, $bytes_copy);
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
	my($exists, $replace, $list, $opcode, @bytes) = @_;
	
	for (@$list) {
		my($text, $id) = @$_;
		
		(my $opcode_inst = $opcode) =~ s/\b$replace\b/$text/g;
		my @bytes_inst = @bytes;
		for (@bytes_inst) {
			s/\b$replace\b/$id/g;
		}
		
		emit($exists, $opcode_inst, @bytes_inst);
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
