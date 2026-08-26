#!/usr/bin/env perl

# decompile a .P file

use Modern::Perl;
use Path::Tiny;
use Data::HexDump;

my %sysvars = (
	ERR_NO		=> 0x4000,
	FLAGS		=> 0x4001,
	ERR_SP		=> 0x4002,
	RAMTOP		=> 0x4004,
	MODE		=> 0x4006,
	PPC			=> 0x4007,
	VERSN		=> 0x4009,
	E_PPC		=> 0x400a,
	D_FILE		=> 0x400c,
	DF_CC		=> 0x400e,
	VARS		=> 0x4010,
	DEST		=> 0x4012,
	E_LINE		=> 0x4014,
	CH_ADD		=> 0x4016,
	X_PTR		=> 0x4018,
	STKBOT		=> 0x401a,
	STKEND		=> 0x401c,
	BREG		=> 0x401e,
	MEM			=> 0x401f,
	FREE1		=> 0x4021,
	DF_SZ		=> 0x4022,
	S_TOP		=> 0x4023,
	LAST_K		=> 0x4025,
	DEBOUNCE	=> 0x4027,
	MARGIN		=> 0x4028,
	NXTLIN		=> 0x4029,
	OLDPPC		=> 0x402b,
	FLAGX		=> 0x402d,
	STRLEN		=> 0x402e,
	T_ADDR		=> 0x4030,
	SEED		=> 0x4032,
	FRAMES		=> 0x4034,
	COORDS_X	=> 0x4036,
	COORDS_Y	=> 0x4037,
	PR_CC		=> 0x4038,
	S_POSN_COL	=> 0x4039,
	S_POSN_ROW	=> 0x403a,
	CDFLAG		=> 0x403b,
	PRBUFF		=> 0x403c,
	MEMBOT		=> 0x405d,
	FREE2		=> 0x407b,
	PROG		=> 0x407d,
);

my %zx81chars = (
	0x00 =>	'CH_SPACE',
	0x0b =>	'CH_QUOTE',	
	0x0c =>	'CH_POUND',	
	0x0d =>	'CH_DOLLAR',	
	0x0e =>	'CH_COLON',	
	0x0f =>	'CH_QUESTION',	
	0x10 =>	'CH_OPEN_PAREN',	
	0x11 =>	'CH_CLOSE_PAREN',	
	0x12 =>	'CH_GREATER_THAN',	
	0x13 =>	'CH_LESS_THAN',	
	0x14 =>	'CH_EQUAL',	
	0x15 =>	'CH_PLUS',	
	0x16 =>	'CH_MINUS',	
	0x17 =>	'CH_MULTIPLY',	
	0x18 =>	'CH_DIVIDE',	
	0x19 =>	'CH_SEMICOLON',	
	0x1a =>	'CH_COMMA',	
	0x1b =>	'CH_DOT',	
	0x1c =>	'CH_0',	
	0x1d =>	'CH_1',	
	0x1e =>	'CH_2',	
	0x1f =>	'CH_3',	
	0x20 =>	'CH_4',	
	0x21 =>	'CH_5',	
	0x22 =>	'CH_6',	
	0x23 =>	'CH_7',	
	0x24 =>	'CH_8',	
	0x25 =>	'CH_9',	
	0x26 =>	'CH_A',	
	0x27 =>	'CH_B',	
	0x28 =>	'CH_C',	
	0x29 =>	'CH_D',	
	0x2a =>	'CH_E',	
	0x2b =>	'CH_F',	
	0x2c =>	'CH_G',	
	0x2d =>	'CH_H',	
	0x2e =>	'CH_I',	
	0x2f =>	'CH_J',	
	0x30 =>	'CH_K',	
	0x31 =>	'CH_L',	
	0x32 =>	'CH_M',	
	0x33 =>	'CH_N',	
	0x34 =>	'CH_O',	
	0x35 =>	'CH_P',	
	0x36 =>	'CH_Q',	
	0x37 =>	'CH_R',	
	0x38 =>	'CH_S',	
	0x39 =>	'CH_T',	
	0x3a =>	'CH_U',	
	0x3b =>	'CH_V',	
	0x3c =>	'CH_W',	
	0x3d =>	'CH_X',	
	0x3e =>	'CH_Y',	
	0x3f =>	'CH_Z',	
	0x40 =>	'CH_RND',	
	0x41 =>	'CH_INKEY_DOLLAR',
	0x42 =>	'CH_PI',
	0x76 => 'CH_NEWLINE',
	0x7e => 'CH_NUMBER',
	0x80 =>	'CH_INV_SPACE',
	0x8b =>	'CH_INV_QUOTE',
	0x8c =>	'CH_INV_POUND',
	0x8d =>	'CH_INV__DOLLAR',
	0x8e =>	'CH_INV_COLON',
	0x8f =>	'CH_INV_QUESTION',
	0x90 =>	'CH_INV_OPEN_PAREN',
	0x91 =>	'CH_INV_CLOSE_PAREN',
	0x92 =>	'CH_INV_GREATER_THAN',
	0x93 =>	'CH_INV_LESS_THAN',
	0x94 =>	'CH_INV_EQUAL',
	0x95 =>	'CH_INV_PLUS',
	0x96 =>	'CH_INV_MINUS',
	0x97 =>	'CH_INV_MULTIPLY',
	0x98 =>	'CH_INV_DIVIDE',
	0x99 =>	'CH_INV_SEMICOLON',
	0x9a =>	'CH_INV_COMMA',
	0x9b =>	'CH_INV_DOT',
	0x9c =>	'CH_INV_0',
	0x9d =>	'CH_INV_1',
	0x9e =>	'CH_INV_2',
	0x9f =>	'CH_INV_3',
	0xa0 =>	'CH_INV_4',
	0xa1 =>	'CH_INV_5',
	0xa2 =>	'CH_INV_6',
	0xa3 =>	'CH_INV_7',
	0xa4 =>	'CH_INV_8',
	0xa5 =>	'CH_INV_9',
	0xa6 =>	'CH_INV_A',
	0xa7 =>	'CH_INV_B',
	0xa8 =>	'CH_INV_C',
	0xa9 =>	'CH_INV_D',
	0xaa =>	'CH_INV_E',
	0xab =>	'CH_INV_F',
	0xac =>	'CH_INV_G',
	0xad =>	'CH_INV_H',
	0xae =>	'CH_INV_I',
	0xaf =>	'CH_INV_J',
	0xb0 =>	'CH_INV_K',
	0xb1 =>	'CH_INV_L',
	0xb2 =>	'CH_INV_M',
	0xb3 =>	'CH_INV_N',
	0xb4 =>	'CH_INV_O',
	0xb5 =>	'CH_INV_P',
	0xb6 =>	'CH_INV_Q',
	0xb7 =>	'CH_INV_R',
	0xb8 =>	'CH_INV_S',
	0xb9 =>	'CH_INV_T',
	0xba =>	'CH_INV_U',
	0xbb =>	'CH_INV_V',
	0xbc =>	'CH_INV_W',
	0xbd =>	'CH_INV_X',
	0xbe =>	'CH_INV_Y',
	0xbf =>	'CH_INV_Z',
	0xc0 =>	'CH_DOUBLE_QUOTE',
	0xc1 =>	'CH_AT',
	0xc2 =>	'CH_TAB',
	0xc4 =>	'CH_CODE',
	0xc5 =>	'CH_VAL',
	0xc6 =>	'CH_LEN',
	0xc7 =>	'CH_SIN',
	0xc8 =>	'CH_COS',
	0xc9 =>	'CH_TAN',
	0xca =>	'CH_ASN',
	0xcb =>	'CH_ACS',
	0xcc =>	'CH_ATN',
	0xcd =>	'CH_LN',
	0xce =>	'CH_EXP',
	0xcf =>	'CH_INT',
	0xd0 =>	'CH_SQR',
	0xd1 =>	'CH_SGN',
	0xd2 =>	'CH_ABS',
	0xd3 =>	'CH_PEEK',
	0xd4 =>	'CH_USR',
	0xd5 =>	'CH_STR_DOLLAR',
	0xd6 =>	'CH_CHR_DOLLAR',
	0xd7 =>	'CH_NOT',
	0xd8 =>	'CH_POWER',
	0xd9 =>	'CH_OR',
	0xda =>	'CH_AND',
	0xdb =>	'CH_LESS_EQUAL',
	0xdc =>	'CH_GREATER_EQUAL',
	0xdd =>	'CH_NOT_EQUAL',
	0xde =>	'CH_THEN',
	0xdf =>	'CH_TO',
	0xe0 =>	'CH_STEP',
	0xe1 =>	'CH_LPRINT',
	0xe2 =>	'CH_LLIST',
	0xe3 =>	'CH_STOP',
	0xe4 =>	'CH_SLOW',
	0xe5 =>	'CH_FAST',
	0xe6 =>	'CH_NEW',
	0xe7 =>	'CH_SCROLL',
	0xe8 =>	'CH_CONT',
	0xe9 =>	'CH_DIM',
	0xea =>	'CH_REM',
	0xeb =>	'CH_FOR',
	0xec =>	'CH_GOTO',
	0xed =>	'CH_GOSUB',
	0xee =>	'CH_INPUT',
	0xef =>	'CH_LOAD',
	0xf0 =>	'CH_LIST',
	0xf1 =>	'CH_LET',
	0xf2 =>	'CH_PAUSE',
	0xf3 =>	'CH_NEXT',
	0xf4 =>	'CH_POKE',
	0xf5 =>	'CH_PRINT',
	0xf6 =>	'CH_PLOT',
	0xf7 =>	'CH_RUN',
	0xf8 =>	'CH_SAVE',
	0xf9 =>	'CH_RAND',
	0xfa =>	'CH_IF',
	0xfb =>	'CH_CLS',
	0xfc =>	'CH_UNPLOT',
	0xfd =>	'CH_CLEAR',
	0xfe =>	'CH_RETURN',
	0xff =>	'CH_COPY',
);

my %reverse_zx81chars;
while (my($k, $v) = each %zx81chars) {
	$reverse_zx81chars{$v} = $k;
}

# main
@ARGV==1 or die "Usage: $0 file.p\n";
my $input_p = shift;

# load memory
my @mem = map {ord} split //, path($input_p)->slurp_raw;

# create asm file
my $output_asm = $input_p =~ s/\.p$/.asm/ir;
open my $asm, ">", $output_asm or die "open $output_asm: $!\n";

say $asm ";", "-" x 79;
say $asm "; decompilation of $input_p generated by $0";
say $asm ";", "-" x 79;
say $asm "";
say $asm "                setfloat zx81";
say $asm "";
say $asm "                org     ".hex4($sysvars{VERSN});
say $asm "";
say $asm ";", "-" x 79;
say $asm "; constants";
say $asm ";", "-" x 79;
say $asm "";
say $asm "SLOW_FLAG:      equ     0x40";
say $asm "FAST_FLAG:      equ     0x00";
say $asm "";
for (sort {$a <=> $b} keys %zx81chars) {
	say $asm sprintf "%-15s equ     %s", $zx81chars{$_}.":", hex2($_);
}
say $asm "";
say $asm ";", "-" x 79;
say $asm "; system variables";
say $asm ";", "-" x 79;
say $asm "";
say $asm "VERSN:          defb    ", peek($sysvars{VERSN});
say $asm "E_PPC:          defw    ", peekw($sysvars{E_PPC});
say $asm "D_FILE:         defw    D_FILE_ADDR";
say $asm "DF_CC:          defw    D_FILE_ADDR+1";
say $asm "VARS:           defw    VARS_ADDR";
say $asm "DEST:           defw    ", hex4(peekw($sysvars{DEST}));
say $asm "E_LINE:         defw    E_LINE_ADDR";
say $asm "CH_ADD:         defw    CH_ADD_ADDR";
say $asm "X_PTR:          defw    ", hex4(peekw($sysvars{X_PTR}));
say $asm "SKTBOT:         defw    STKBOT_ADDR";
say $asm "SKTEND:         defw    STKEND_ADDR";
say $asm "BREG:           defb    ", peek($sysvars{BREG});
say $asm "MEM:            defw    MEMBOT";
say $asm "FREE1:          defb    ", peek($sysvars{FREE1});
say $asm "DF_SZ:          defb    ", peek($sysvars{DF_SZ});
say $asm "S_TOP:          defw    ", peek($sysvars{S_TOP});
say $asm "LAST_K:         defw    ", hex4(peekw($sysvars{LAST_K}));
say $asm "DEBOUNCE:       defb    ", hex2(peek($sysvars{DEBOUNCE}));
say $asm "MARGIN:         defb    ", peek($sysvars{MARGIN});

if (peekw($sysvars{NXTLIN}) == $sysvars{PROG}) {
	say $asm "NXTLIN:         defw    PROG";
} 
elsif (peekw($sysvars{NXTLIN}) == peekw($sysvars{D_FILE})) {
	say $asm "NXTLIN:         defw    D_FILE_ADDR";
} 
else { 
	say $asm "NXTLIN:         defw    ", hex4(peekw($sysvars{NXTLIN}));
}

say $asm "OLDPPC:         defw    ", peek($sysvars{OLDPPC});
say $asm "FLAGX:          defb    ", hex2(peek($sysvars{FLAGX}));
say $asm "STRLEN:         defw    ", peekw($sysvars{STRLEN});
say $asm "T_ADDR:         defw    ", hex4(peekw($sysvars{T_ADDR}));
say $asm "SEED:           defw    ", hex4(peekw($sysvars{SEED}));
say $asm "FRAMES:         defw    ", hex4(peekw($sysvars{FRAMES}));
say $asm "COORDS_X:       defb    ", peek($sysvars{COORDS_X});
say $asm "COORDS_Y:       defb    ", peek($sysvars{COORDS_Y});
say $asm "PR_CC:          defb    (PRBUFF+", 
									0x4000+peek($sysvars{PR_CC})-$sysvars{PRBUFF}, ") & 0xFF";
say $asm "S_POSN_COL:     defb    ", peek($sysvars{S_POSN_COL});
say $asm "S_POSN_ROW:     defb    ", peek($sysvars{S_POSN_ROW});
if (peekw($sysvars{CDFLAG}) == 0x40) {
say $asm "CDFLAG:         defb    SLOW_FLAG";
} elsif (peekw($sysvars{CDFLAG}) == 0x00) {
say $asm "CDFLAG:         defb    FAST_FLAG";
} else {
say $asm "CDFLAG:         defb    ", hex2(peek($sysvars{CDFLAG}));
}
say $asm "PRBUFF:";
dump_basic_text($asm, $sysvars{PRBUFF}, $sysvars{PRBUFF} + 33);
say $asm "";
say $asm "MEMBOT:";
dump_bytes($asm, $sysvars{MEMBOT}, $sysvars{MEMBOT} + 30);

say $asm "";
say $asm "FREE2:          defw    ", peekw($sysvars{FREE2});
say $asm "";
say $asm ";", "-" x 79;
say $asm "; BASIC program";
say $asm ";", "-" x 79;
say $asm "";
say $asm "PROG:";

say $asm "";
dump_basic($asm, $sysvars{PROG}, peekw($sysvars{D_FILE}));
say $asm "";
say $asm ";", "-" x 79;
say $asm "; display";
say $asm ";", "-" x 79;
say $asm "";
say $asm "D_FILE_ADDR:";
dump_display($asm, peekw($sysvars{D_FILE}), peekw($sysvars{VARS}));
say $asm "";
say $asm ";", "-" x 79;
say $asm "; variables";
say $asm ";", "-" x 79;
say $asm "";
say $asm "VARS_ADDR:      defb    0x80";
say $asm "";
say $asm ";", "-" x 79;
say $asm "; workspace";
say $asm ";", "-" x 79;
say $asm "";
say $asm "E_LINE_ADDR:";

# some .p files have an extra byte stored after E_LINE; add it
my $end_addr = $sysvars{VERSN} + scalar(@mem);
if ($end_addr == peekw($sysvars{E_LINE}) + 1) {
	say $asm " " x 16, "defb    ", hex2(peek($end_addr - 1));
}

say $asm "";
say $asm "CH_ADD_ADDR:    equ     E_LINE_ADDR+".
							(peekw($sysvars{CH_ADD}) - peekw($sysvars{E_LINE}));
say $asm "STKBOT_ADDR:    equ     E_LINE_ADDR+".
							(peekw($sysvars{STKBOT}) - peekw($sysvars{E_LINE}));
say $asm "STKEND_ADDR:    equ     STKBOT_ADDR+".
							(peekw($sysvars{STKEND}) - peekw($sysvars{STKBOT}));

close $asm;

# assemble
run("z88dk-z80asm -b -m -l $output_asm");

# get symbol map
my $output_map = $output_asm =~ s/\.asm$/.map/ir;
my %symbols;
my $fh;
open $fh, "<", $output_map or die "open $output_map: $!\n";
while (<$fh>) {
	/^(\w+)\s*=\s*\$([0-9a-fA-F]+)/ and $symbols{$1} = hex($2);
	# check sysvars
	if (exists $sysvars{$1} && $symbols{$1} != $sysvars{$1}) {
		die "$1 mismatch, expected ", hex4($sysvars{$1}), ", got ", hex4($symbols{$1}), "\n";
	}
}

# make hex dump
my $input_dump = $input_p.".dump";
open $fh, ">", $input_dump or die "open $input_dump: $!\n";
print $fh HexDump(path($input_p)->slurp_raw);

my $output_bin = $output_asm =~ s/\.asm$/.bin/ir;
my $output_dump = $output_bin.".dump";
open $fh, ">", $output_dump or die "open $output_dump: $!\n";
print $fh HexDump(path($output_bin)->slurp_raw);

# compare
run("diff $input_dump $output_dump");

# ---

sub peek {
	my($addr) = @_;
	my $save_addr = $sysvars{VERSN};
	die sprintf "address 0x%04X out of range", $addr
		if $addr < $save_addr || $addr - $save_addr >= @mem;
	return $mem[$addr - $save_addr];
}

sub peekw {
	my($addr) = @_;
	return peek($addr) | (peek($addr+1) << 8);
}

sub peekw_be {
	my($addr) = @_;
	return (peek($addr) << 8) | peek($addr+1);
}

sub dump_basic {
	my($fh, $addr, $end) = @_;
	
	while ($addr < $end) {
		my $line_num = peekw_be($addr); $addr += 2;
		my $size = peekw($addr); $addr += 2;
		my $line_str = sprintf "%05d", $line_num;
		my $line_label = "L".$line_str;
		my $body_start_label = "L".$line_str."_start";
		my $body_end_label = "L".$line_str."_end";
		say $fh $line_label, ":";
		say $fh " " x 16, "defdb   $line_num";
		say $fh " " x 16, "defw    $body_end_label - $body_start_label";
		say $fh $body_start_label, ":";
		if (peek($addr) == $reverse_zx81chars{CH_REM}) {
			dump_basic_text($fh, $addr, $addr + 1);
			dump_bytes($fh, $addr + 1, $addr + $size - 1);
			dump_basic_text($fh, $addr + $size - 1, $addr + $size);
		}
		else {
			dump_basic_text($fh, $addr, $addr + $size);
		}
		say $fh $body_end_label, ":";
		say $fh "";
		
		$addr += $size;
	}
}

sub dump_bytes {
	my($fh, $addr, $end) = @_;
	
	while ($addr < $end) {
		my $ch = peek($addr++);
		say $fh " " x 16, "defb    ", hex2($ch);
	}
}

sub dump_basic_text {
	my($fh, $addr, $end) = @_;
	
	my $in_quotes = 0;
	while ($addr < $end) {
		my $ch = peek($addr);
		if (!$in_quotes && $ch >= $reverse_zx81chars{CH_0} && $ch <= $reverse_zx81chars{CH_9}) {
			$addr = dump_number($fh, $addr);
		}
		elsif (exists $zx81chars{$ch}) {
			if ($ch == $reverse_zx81chars{CH_QUOTE}) {
				$in_quotes = !$in_quotes;
			}
			say $fh " " x 16, "defb    ", $zx81chars{$ch};
			$addr++;
		}
		else {
			say $fh " " x 16, "defb    ", hex2($ch);
			$addr++;
		}
	}
}

sub dump_number {
	my($fh, $addr, $end) = @_;
	
	my $start = $addr;
	my $number = "";
	my $found_dot = 0;
	my $found_e = 0;
	my $found_e_sign = 0;
	
	while (1) {
		my $ch = peek($addr);
		if ($ch == $reverse_zx81chars{CH_NUMBER}) {
			$addr++;
			last;
		}
		elsif ($ch >= $reverse_zx81chars{CH_0} && $ch <= $reverse_zx81chars{CH_9}) {
			$number .= chr(ord("0") + $ch - $reverse_zx81chars{CH_0});
			$addr++;
		}
		elsif ($ch == $reverse_zx81chars{CH_DOT}) {
			die "too many dots in $number" if $found_dot++;
			$number .= ".";
			$addr++;
		}
		elsif ($ch == $reverse_zx81chars{CH_E}) {
			die "too many E's in $number" if $found_e++;
			$number .= "e";
			$addr++;
		}
		elsif ($ch == $reverse_zx81chars{CH_MINUS}) {
			die "minus not valid" unless $found_e;
			die "too many minus's in $number" if $found_e_sign++;
			$number .= "-";
			$addr++;
		}
		else {
			die "invalid character $ch, collected $number";
		}
	}
	
	for ($start .. $addr - 1) {
		say $fh " " x 16, "defb    ", $zx81chars{peek($_)};
	}
	say $fh " " x 16, "float   $number";
	$addr += 5;
	
	return $addr;
}

sub dump_display {
	my($fh, $addr, $end) = @_;
	
	peek($addr) == 0x76 or die "invalid display";
	say $fh " " x 16, "defb    CH_NEWLINE";
	$addr++;
	
	for my $line (0 .. 23) {
		say $fh sprintf("line_%02d", $line), ":";
		my $start = $addr;
		while (peek($addr) != 0x76) {
			$addr++;
		}
		$addr++;
		dump_basic_text($fh, $start, $addr);
		$addr = $start;
	}
}

sub hex2 {
	my($n) = @_;
	return sprintf("0x%02X", $n);
}

sub hex4 {
	my($n) = @_;
	return sprintf("0x%04X", $n);
}

sub run {
	my($cmd) = @_;
	print "% $cmd\n";
	system($cmd)==0 or die "command failed\n";
}
