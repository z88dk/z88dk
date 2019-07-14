#------------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
#
# Z80/Z180/RCM2000/RCM3000 assembly table
# Generate test code and parsing tables for the cpus defined in cpu.def
#
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------
use Modern::Perl;

#------------------------------------------------------------------------------
# Programatic opcode generator
# asm placeholders:
#	%s	signed byte
#	%n	unsigned byte
#	%m	unsigned word
#	%M	unsigned word, big-endian
#	%j	jr offset
#	%c	constant (im, bit, rst, ...)
#	%d	signed register indirect offset
#	%u	unsigned register indirect offset
#	%t	temp jump label
#	@label	unsigned word with given global label address
#------------------------------------------------------------------------------
my @CPUS = qw( z80 z80n z180 r2k r3k );

my @R8	= qw( b c d e h l      a );
my @R8I	= qw( b c d e h l (hl) a );
my @R8F	= qw( b c d e h l f    a );
my @R16SP = qw( bc de hl sp );
my @R16AF = qw( bc de hl af );
my @ALU = qw( add adc sub sbc and xor or cp );
my @TEST= qw( tst test );
my @ROTA= qw( rlca rrca rla rra );
my @ROT = qw( rlc rrc rl rr sla sra sll sli srl );
my @BIT = qw( bit res set );
my @FLAGS = qw( _nz _z _nc _c _po _pe _nv _v _lz _lo _p _m );
my %INV_FLAG = qw( 	_nz	_z 
					_z 	_nz
					_nc _c 
					_c	_nc
					_po _pe 
					_pe	_po
					_nv _v 
					_v	_nv
					_lz _lo 
					_lo	_lz
					_p 	_m
					_m	_p );
my @X	= qw( ix iy );
my @DIS	= ('0', '%d');
my @IO	= ('', qw( ioi ioe ));
my @ALTD= ('', qw( altd ));
my @A_  = ('a, ', '');

my %V = (
	'' => '',
	b => 0, c => 1, d => 2, e => 3, h => 4, l => 5, '(hl)' => 6, f => 6, a => 7,
	bc => 0, de => 1, hl => 2, sp => 3, af => 3,
	_nz => 0, _z => 1, _nc => 2, _c => 3, 
	_po => 4, _pe => 5,
	_nv => 4, _v => 5,
	_lz => 4, _lo => 5, _p => 6, _m => 7,
	add => 0, adc => 1, sub => 2, sbc => 3, and => 4, xor => 5, or => 6, cp => 7,
	rlca => 0, rrca => 1, rla => 2, rra => 3,
	rlc => 0, rrc => 1, rl => 2, rr => 3, sla => 4, sra => 5, sll => 6, sli => 6, srl => 7, 
	bit => 1, res => 2, set => 3,
	ix => 0xDD, iy => 0xFD, 
	altd => 0x76, ioi => 0xD3, ioe => 0xDB,
);

#------------------------------------------------------------------------------
# build %Opcodes
#------------------------------------------------------------------------------
my %Opcodes = ();
for my $cpu (@CPUS) {
	my $rabbit	= ($cpu =~ /^r/);
	my $r3k		= ($cpu =~ /^r3k/);
	my $z80 	= ($cpu =~ /^z80/);
	my $z80n	= ($cpu =~ /^z80n/);
	my $z180 	= ($cpu =~ /^z180/);
	my $zilog	= ($cpu =~ /^z/);
	
	# 8-bit load group
	for my $r (@R8I) { 
		for my $s (@R8I) {
			my $op = 0x40 + $V{$r}*8 + $V{$s};
			add_opc($cpu, "ld $r, $s", $op);
		}
		add_opc($cpu, "ld $r, %n", 0x06 + $V{$r}*8, '%n');
	}
	add_opc($cpu, "ld a, (%m)", 0x3A, '%m', '%m');
	add_opc($cpu, "ld (%m), a", 0x32, '%m', '%m');
	add_opc($cpu, "ld (bc), a", 0x02);
	add_opc($cpu, "ld a, (bc)", 0x0A);
	add_opc($cpu, "ld (de), a", 0x12);
	add_opc($cpu, "ld a, (de)", 0x1A);

	# 8-bit ALU group
	for my $op (@ALU) {
		for my $r (@R8I) {
			for my $a (@A_) {
				add_opc($cpu, "$op $a$r", 0x80 + $V{$op}*8 + $V{$r});
			}
		}
		for my $a (@A_) {
			add_opc($cpu, "$op $a%n", 0xC6 + $V{$op}*8, '%n');
		}
	}
	for my $r (@R8I) { 
		add_opc($cpu, "inc $r", 0x04 + $V{$r}*8);
		add_opc($cpu, "dec $r", 0x05 + $V{$r}*8);
		
		for my $op (@TEST) {
			for my $a (@A_) {
				if ($z180) {
					add_opc($cpu, "$op $a$r",  0xED, 0x04 + $V{$r}*8);
					add_opc($cpu, "$op $a%n",  0xED, 0x64, '%n');
				}
				elsif ($z80n) {
					add_opc($cpu, "$op $a%n",  0xED, 0x27, '%n');
				}
			}
		}
	}
	
	if ($zilog) {
		add_opc($cpu, "daa", 0x27);
		add_opc($cpu, "rrd", 0xED, 0x67);
		add_opc($cpu, "rld", 0xED, 0x6F);
	}
	elsif ($rabbit) {
		add_opc($cpu, "daa", 0xCD, '@__z80asm__daa');
		add_opc($cpu, "rrd", 0xCD, '@__z80asm__rrd');
		add_opc($cpu, "rld", 0xCD, '@__z80asm__rld');
	}
	
	add_opc($cpu, "cpl", 		0x2F);
	add_opc($cpu, "cpl a", 		0x2F);
	add_opc($cpu, "cpl a'", 	$V{altd}, 0x2F) if $rabbit;
	add_opc($cpu, "altd cpl",	$V{altd}, 0x2F) if $rabbit;
	add_opc($cpu, "altd cpl a",	$V{altd}, 0x2F) if $rabbit;
	
	add_opc($cpu, "neg", 		0xED, 0x44);
	add_opc($cpu, "neg a", 		0xED, 0x44);
	add_opc($cpu, "neg a'", 	$V{altd}, 0xED, 0x44) if $rabbit;
	add_opc($cpu, "altd neg",	$V{altd}, 0xED, 0x44) if $rabbit;
	add_opc($cpu, "altd neg a",	$V{altd}, 0xED, 0x44) if $rabbit;
	
	add_opc($cpu, "ccf", 		0x3F);
	add_opc($cpu, "ccf f", 		0x3F);
	add_opc($cpu, "ccf'", 		$V{altd}, 0x3F) if $rabbit;
	add_opc($cpu, "ccf f'", 	$V{altd}, 0x3F) if $rabbit;
	add_opc($cpu, "altd ccf",	$V{altd}, 0x3F) if $rabbit;
	add_opc($cpu, "altd ccf f",	$V{altd}, 0x3F) if $rabbit;
	
	add_opc($cpu, "scf", 		0x37);
	add_opc($cpu, "scf f", 		0x37);
	add_opc($cpu, "scf'", 		$V{altd}, 0x37) if $rabbit;
	add_opc($cpu, "scf f'", 	$V{altd}, 0x37) if $rabbit;
	add_opc($cpu, "altd scf",	$V{altd}, 0x37) if $rabbit;
	add_opc($cpu, "altd scf f",	$V{altd}, 0x37) if $rabbit;
	
	# 16-bit load group
	for my $r (@R16SP) {
		add_opc($cpu, "ld $r, %m", 0x01 + $V{$r}*16, '%m', '%m');
		if ($r eq 'hl') {
			add_opc($cpu, "ld $r, (%m)", 0x2A, '%m', '%m');
			add_opc($cpu, "ld (%m), $r", 0x22, '%m', '%m');
			
			for my $x (@X) {
				add_opc($cpu, "ld $x, %m", $V{$x}, 0x01 + $V{$r}*16, '%m', '%m');
				add_opc($cpu, "ld $x, (%m)", $V{$x}, 0x2A, '%m', '%m');
				add_opc($cpu, "ld (%m), $x", $V{$x}, 0x22, '%m', '%m');
			}
		}
		else {
			add_opc($cpu, "ld $r, (%m)", 0xED, 0x4B + $V{$r}*16, '%m', '%m');
			add_opc($cpu, "ld (%m), $r", 0xED, 0x43 + $V{$r}*16, '%m', '%m');
		}
	}
	
	add_opc($cpu, "ld sp, hl", 0xF9);
	for my $x (@X) {
		add_opc($cpu, "ld sp, $x", $V{$x}, 0xF9);
	}
	
	for my $r (@R16AF) {
		add_opc($cpu, "push $r", 0xC5 + $V{$r}*16);
		add_opc($cpu, "pop $r", 0xC1 + $V{$r}*16);
		
		if ($r eq 'hl') {
			for my $x (@X) {
				add_opc($cpu, "push $x", $V{$x}, 0xC5 + $V{$r}*16);
				add_opc($cpu, "pop $x", $V{$x}, 0xC1 + $V{$r}*16);
			}
		}
	}
	
	if ($rabbit) {
		add_opc($cpu, "push ip", 0xED, 0x76);
		add_opc($cpu, "pop ip", 0xED, 0x7E);
	}
	
	if ($r3k) {
		add_opc($cpu, "push su", 0xED, 0x66) if $r3k;
		add_opc($cpu, "pop su", 0xED, 0x6E) if $r3k;
	}
	
	if ($rabbit) {
		for my $x (@X) {
			add_opc($cpu, "ld hl, $x", $V{$x}, 0x7C);
			add_opc($cpu, "ld $x, hl", $V{$x}, 0x7D);
		}
		
		for ([hl => 0xDD], [ix => ()], [iy => 0xFD]) {
			my($r, @pfx) = @$_;
		
			add_opc($cpu, "ld hl, ($r+%d)", @pfx, 0xE4, '%d');
			add_opc($cpu, "ld ($r+%d), hl", @pfx, 0xF4, '%d');
		}
			
		for ([hl => ()], [ix => 0xDD], [iy => 0xFD]) {
			my($r, @pfx) = @$_;
		
			add_opc($cpu, "ld (sp+%u), $r", @pfx, 0xD4, '%u');
			add_opc($cpu, "ld $r, (sp+%u)", @pfx, 0xC4, '%u');
		}
		
		for my $r (qw(bc de hl)) {
			for my $s (qw(bc de)) {
				add_opc($cpu, "ld $r', $s", 	0xED, 0x41 + $V{$r}*16 + (1-$V{$s})*8);
				add_opc($cpu, "altd ld $r, $s", 0xED, 0x41 + $V{$r}*16 + (1-$V{$s})*8);
			}
		}
		
		for ([hl => 0xED], [ix => 0xDD], [iy => 0xFD]) {
			my($r, $pfx) = @$_;
			
			add_opc($cpu, "ldp (%m), $r", $pfx, 0x65, '%m', '%m');
			add_opc($cpu, "ldp $r, (%m)", $pfx, 0x6D, '%m', '%m');
			add_opc($cpu, "ldp ($r), hl", $pfx, 0x64);
			add_opc($cpu, "ldp hl, ($r)", $pfx, 0x6C);
		}
	}
	
	# exchange group
	add_opc($cpu, "ex af, af'", 0x08);
	add_opc($cpu, "ex af, af",  0x08);
	
	add_opc($cpu, "exx",  0xD9);
	
	if ($zilog) {
		add_opc($cpu, "ex (sp), hl", 0xE3);
	}
	elsif ($rabbit) {
		add_opc($cpu, "ex (sp), hl", 0xED, 0x54);
		add_opc($cpu, "ex (sp), hl'", $V{altd}, 0xED, 0x54);
		add_opc($cpu, "altd ex (sp), hl", $V{altd}, 0xED, 0x54);
	}
	else {}
	
	for my $x (@X) {
		add_opc($cpu, "ex (sp), $x", $V{$x}, 0xE3);
	}
	
	add_opc($cpu, "ex de, hl", 0xEB);
	if ($rabbit) {
		add_opc($cpu, "ex de', hl", 0xE3);
		add_opc($cpu, "ex de, hl'", 0x76, 0xEB);
		add_opc($cpu, "ex de', hl'", 0x76, 0xE3);
		
		add_opc($cpu, "altd ex de, hl", 0x76, 0xEB);
		add_opc($cpu, "altd ex de', hl", 0x76, 0xE3);
	}
	
	# 16-bit ALU group
	for my $r (@R16SP) {
		add_opc($cpu, "add hl, $r", 0x09 + $V{$r}*16);
		add_opc($cpu, "sbc hl, $r", 0xED, 0x42 + $V{$r}*16);
		add_opc($cpu, "adc hl, $r", 0xED, 0x4A + $V{$r}*16);
		
		add_opc($cpu, "inc $r", 0x03 + $V{$r}*16);
		add_opc($cpu, "dec $r", 0x0B + $V{$r}*16);
	}
	
	for my $x (@X) {
		for my $r (@R16SP) {
			add_opc($cpu, "add $x, ".replace($r, qr/hl/, $x), $V{$x}, 0x09 + $V{$r}*16);
		}
		add_opc($cpu, "inc $x", $V{$x}, 0x03 + 2*16);
		add_opc($cpu, "dec $x", $V{$x}, 0x0B + 2*16);
	}
	
	if ($rabbit) {
		add_opc($cpu, "add sp, %s", 0x27, '%s');
		
		for ([hl => ()], [ix => 0xDD], [iy => 0xFD]) {
			my($r, @pfx) = @$_;
			
			add_opc($cpu, "and $r, de", @pfx, 0xDC);
			add_opc($cpu, "or $r, de", @pfx, 0xEC);
			add_opc($cpu, "bool $r", @pfx, 0xCC);
		}
	}
	
	# Multiply
	if ($z180) {
		for my $r (@R16SP) {
			add_opc($cpu, "mlt $r", 0xED, 0x4C + $V{$r}*16);
		}
	}
	elsif ($z80n) {
		add_opc($cpu, "mul d, e", 0xED, 0x30);
		add_opc($cpu, "mul de",   0xED, 0x30);
		add_opc($cpu, "mlt de",   0xED, 0x30);
	}
	elsif ($rabbit) {
		add_opc($cpu, "mul", 0xF7);
	}
	else {}
	
	if ($r3k) {
		add_opc($cpu, "uma", 0xED, 0xC0);
		add_opc($cpu, "ums", 0xED, 0xC8);
	}
	
	# 8-bit rotate and shift group
	for my $op (@ROTA) {
		add_opc($cpu, $op, 0x07 + $V{$op}*8);
	}
	
	for my $op (@ROT) {
		next if $op =~ /sll|sli/ && !$zilog;
		for my $r (@R8I) {
			add_opc($cpu, "$op $r", 0xCB, $V{$op}*8 + $V{$r});
		}
	}
	
	if ($z80) {
		for my $op (@ROT) {
			for my $x (@X) {
				for my $r (@R8) {
					add_opc($cpu, "$op ($x+%d), $r", $V{$x}, 0xCB, '%d', $V{$op}*8 + $V{$r});
				}
			}
		}			
	}
	
	# bit set, reset and test group
	for my $op (@BIT) {
		for my $r (@R8I) {
			add_opc($cpu, "$op %c, $r", 0xCB, ($V{$op}*0x40 + $V{$r})."+8*%c(0..7)");
		}
	}
	
	# 16-bit rotate and shift group
	if ($rabbit) {
		add_opc($cpu, "rl de", 0xF3);
		add_opc($cpu, "rr de", 0xFB);
		for ([hl => ()], [ix => 0xDD], [iy => 0xFD]) {
			my($x, @pfx) = @$_;
			add_opc($cpu, "rr $x", @pfx, 0xFC);
		}
	}
	
	# CPU control group
	add_opc($cpu, "nop", 0x00);
	add_opc($cpu, "halt", 0x76) if $zilog;
	add_opc($cpu, "slp", 0xED, 0x76) if $z180;
	
	if ($r3k) {
		add_opc($cpu, "rdmode", 0xED, 0x7F);
		add_opc($cpu, "setusr", 0xED, 0x6F);
		add_opc($cpu, "sures", 0xED, 0x7D);
		add_opc($cpu, "syscall", 0xED, 0x75);
	}
	
	# Interrupt control group
	if ($zilog) {
		add_opc($cpu, "di", 0xF3);
		add_opc($cpu, "ei", 0xFB);

		add_opc($cpu, "im %c", 0xED, "%c(0..2)==0?0x46:%c==1?0x56:0x5E");

		add_opc($cpu, "ld i, a", 0xED, 0x47);
		add_opc($cpu, "ld a, i", 0xED, 0x57);
		add_opc($cpu, "ld r, a", 0xED, 0x4F);
		add_opc($cpu, "ld a, r", 0xED, 0x5F);
	}
	
	if ($rabbit) {
		add_opc($cpu, "ld eir, a", 0xED, 0x47);
		add_opc($cpu, "ld a, eir", 0xED, 0x57);
		add_opc($cpu, "ld iir, a", 0xED, 0x4F);
		add_opc($cpu, "ld a, iir", 0xED, 0x5F);
	
		add_opc($cpu, "ipset %c", 0xED, "%c(0..3)==0?0x46:%c==1?0x56:%c==2?0x4E:0x5E");
		add_opc($cpu, "ipres", 0xED, 0x5D);
	}

	add_opc($cpu, "reti", 0xED, 0x4D);
	add_opc($cpu, "retn", 0xED, 0x45) if $zilog;
	add_opc($cpu, "idet", 0x5B) if $r3k;
	
	# Jump group
	add_opc($cpu, "jr %j", 0x18, '%j');
	add_opc($cpu, "jp %m", 0xC3, '%m', '%m');

	# TODO: check that address is corretly computed in DJNZ B', LABEL - 76 10 FE or 76 10 FD
	add_opc($cpu, "djnz %j", 0x10, '%j');
	add_opc($cpu, "djnz b, %j", 0x10, '%j');
	
	
	for my $_f (@FLAGS) {
		my $f = substr($_f, 1);		# remove leading _
		if ($f =~ /lz|lo/) {
			add_opc($cpu, "jp $f, %m", 0xC2 + $V{$_f}*8, '%m', '%m') if $rabbit;
		}
		elsif ($f =~ /^(nz|z|nc|c)$/) {
			add_opc($cpu, "jr $f, %j", 0x20 + $V{$_f}*8, '%j');
			add_opc($cpu, "jp $f, %m", 0xC2 + $V{$_f}*8, '%m', '%m');
		}
		else {
			add_opc($cpu, "jp $f, %m", 0xC2 + $V{$_f}*8, '%m', '%m');
		}
	}
	
	for ([hl => ()], [ix => 0xDD], [iy => 0xFD]) {
		my($x, @pfx) = @$_;
		add_opc($cpu, "jp ($x)", @pfx, 0xE9);
	}

	if ($rabbit) {
		# TODO: LJP not supported
		add_opc($cpu, "ld xpc, a", 0xED, 0x67);
		add_opc($cpu, "ld a, xpc", 0xED, 0x77);
	}
	
	# Call and return group
	add_opc($cpu, "call %m", 0xCD, '%m', '%m');
	add_opc($cpu, "ret", 0xC9);
	
	for my $_f (@FLAGS) {
		my $f = substr($_f, 1);					# remove leading _
		my $_inv_f = $INV_FLAG{$_f};			# inverted flag
		my $inv_f = substr($_inv_f, 1);			# remove leading _

		if ($rabbit) {
			# TODO: LCALL not supported
			if ($f =~ /^(nz|z|nc|c)$/) {
				add_opc($cpu, "call $f, %m", 
								0x20 + $V{$_inv_f}*8, 3,			# jump !flag
								0xCD, '%m', '%m');					# call 
			}
			else {
				add_opc($cpu, "call $f, %m", 
								0xC2 + $V{$_inv_f}*8, '%t', '%t',	# jump !flag, label
								0xCD, '%m', '%m');					# call 
			}
		}
		else {
			if ($f !~ /lz|lo/) {
				add_opc($cpu, "call $f, %m", 0xC4 + $V{$_f}*8, '%m', '%m');			
			}
		}
		
		if ($f =~ /lz|lo/ && $rabbit || $f !~ /lz|lo/) {
			# TODO: LRET not supported
			add_opc($cpu, "ret $f", 0xC0 + $V{$_f}*8);
		}
	}
	
	add_opc($cpu, "rst %c", "0xC7+%c");
	
	# Block transfer group
	add_opc($cpu, "ldi", 	0xED, 0xA0);
	add_opc($cpu, "ldir", 	0xED, 0xB0);
	add_opc($cpu, "ldd", 	0xED, 0xA8);
	add_opc($cpu, "lddr", 	0xED, 0xB8);

	if ($r3k) {
		add_opc($cpu, "ldisr", 	0xED, 0x90);
		add_opc($cpu, "lddsr", 	0xED, 0x98);
		
		add_opc($cpu, "lsdr", 	0xED, 0xF8);
		add_opc($cpu, "lsir", 	0xED, 0xF0);
		add_opc($cpu, "lsddr", 	0xED, 0xD8);
		add_opc($cpu, "lsidr", 	0xED, 0xD0);
	}

	# Search group
	if ($zilog) {
		add_opc($cpu, "cpi", 	0xED, 0xA1);
		add_opc($cpu, "cpir", 	0xED, 0xB1);
		add_opc($cpu, "cpd", 	0xED, 0xA9);
		add_opc($cpu, "cpdr", 	0xED, 0xB9);
	}
	else  {
		add_opc($cpu, "cpi", 	0xCD, '@__z80asm__cpi');
		add_opc($cpu, "cpir", 	0xCD, '@__z80asm__cpir');
		add_opc($cpu, "cpd", 	0xCD, '@__z80asm__cpd');
		add_opc($cpu, "cpdr", 	0xCD, '@__z80asm__cpdr');
	}

	# Input and Output Group
	if ($zilog) {
		add_opc($cpu, "in a, (%n)", 		0xDB, '%n');
		add_opc($cpu, "in (c)", 			0xED, 0x40 + $V{f}*8);
		add_opc($cpu, "in0 (%n)", 			0xED, 0x00 + $V{f}*8, '%n') if $z180;
		for my $r (@R8F) {
			add_opc($cpu, "in $r, (c)", 	0xED, 0x40 + $V{$r}*8);
			add_opc($cpu, "in0 $r, (%n)", 	0xED, 0x00 + $V{$r}*8, '%n') if $z180;
		}
		
		add_opc($cpu, "out (%n), a", 		0xD3, '%n');
		add_opc($cpu, "out (c), %c", 		0xED, '0x41+%c(0)+6*8');

		for my $r (@R8) {
			add_opc($cpu, "out (c), $r", 	0xED, 0x41 + $V{$r}*8);
			add_opc($cpu, "out0 (%n), $r", 	0xED, 0x01 + $V{$r}*8, '%n') if $z180;
		}
		
		add_opc($cpu, "tstio %n", 			0xED, 0x74, '%n') if $z180;

		add_opc($cpu, "ini", 	0xED, 0xA2);
		add_opc($cpu, "inir", 	0xED, 0xB2);
		add_opc($cpu, "ind", 	0xED, 0xAA);
		add_opc($cpu, "indr", 	0xED, 0xBA);

		add_opc($cpu, "outi", 	0xED, 0xA3);
		add_opc($cpu, "otir", 	0xED, 0xB3);
		add_opc($cpu, "outd", 	0xED, 0xAB);
		add_opc($cpu, "otdr", 	0xED, 0xBB);

		if ($z180) {
			add_opc($cpu, "otdm", 	0xED, 0x8B);
			add_opc($cpu, "otdmr", 	0xED, 0x9B);
			add_opc($cpu, "otim", 	0xED, 0x83);
			add_opc($cpu, "otimr", 	0xED, 0x93);
		}
	}
	
	# Z80N opcodes for ZX Next
	if ($z80n) {
		add_opc($cpu, "swapnib", 		0xED, 0x23);
		add_opc($cpu, "mirror a", 		0xED, 0x24);
		add_opc($cpu, "bsla de,b",		0xED, 0x28);
		add_opc($cpu, "bsra de,b",		0xED, 0x29);
		add_opc($cpu, "bsrl de,b",		0xED, 0x2A);
		add_opc($cpu, "bsrf de,b",		0xED, 0x2B);
		add_opc($cpu, "brlc de,b",		0xED, 0x2C);
		
#		add_opc($cpu, "mirror de", 		0xED, 0x26);
		
		add_opc($cpu, "add hl, a",		0xED, 0x31);
		add_opc($cpu, "add de, a",		0xED, 0x32);
		add_opc($cpu, "add bc, a",		0xED, 0x33);
		
		add_opc($cpu, "add hl, %m",		0xED, 0x34, '%m', '%m');
		add_opc($cpu, "add de, %m",		0xED, 0x35, '%m', '%m');
		add_opc($cpu, "add bc, %m",		0xED, 0x36, '%m', '%m');
		
		add_opc($cpu, "push %M",	 	0xED, 0x8A, '%M', '%M');
#		add_opc($cpu, "pop x",		 	0xED, 0x8B);

		add_opc($cpu, "outinb",			0xED, 0x90);

		add_opc($cpu, "mmu %c, %n",		0xED, 0x91, '0x50+%c(0..7)', '%n');
		for my $page (0..7) {
			add_opc($cpu, "mmu$page %n",0xED, 0x91, 0x50+$page, '%n');
		}

		add_opc($cpu, "mmu %c, a",		0xED, 0x92, '0x50+%c(0..7)');
		for my $page (0..7) {
			add_opc($cpu, "mmu$page a",	0xED, 0x92, 0x50+$page);
		}

		add_opc($cpu, "nextreg %n, %n",	0xED, 0x91, '%n', '%n');
		add_opc($cpu, "nextreg %n, a",	0xED, 0x92, '%n');
		
		add_opc($cpu, "pixeldn",		0xED, 0x93);
		add_opc($cpu, "pixelad",		0xED, 0x94);
		add_opc($cpu, "setae",			0xED, 0x95);

		add_opc($cpu, "jp (c)",			0xED, 0x98);

		add_opc($cpu, "ldix",			0xED, 0xA4);
		add_opc($cpu, "ldws",			0xED, 0xA5);
		add_opc($cpu, "lddx",			0xED, 0xAC);
		add_opc($cpu, "ldirx",			0xED, 0xB4);
		add_opc($cpu, "ldpirx",			0xED, 0xB7);
		add_opc($cpu, "lddrx",			0xED, 0xBC);
	}
}

#------------------------------------------------------------------------------
# build %Parser
#------------------------------------------------------------------------------
my %Parser = ();

for my $asm (sort keys %Opcodes) {
	my $tokens = parser_tokens($asm);
	
	# asm for swap_ix_iy
	(my $asm_swap = $asm) =~ s/\b(ix|iy)/ $1 eq 'ix' ? 'iy' : 'ix' /ge;
	
	# check for parens
	my $parens;
	if    ($asm =~ /\(%[nm]\)/) {		$parens = 'expr_in_parens'; }
	elsif ($asm =~ /%[snmjc]/) {		$parens = 'expr_no_parens'; }
	else {								$parens = 'no_expr';   }
		
	for my $cpu (sort keys %{$Opcodes{$asm}}) {
		my @bin = @{$Opcodes{$asm}{$cpu}};
		my @bin_swap = @{$Opcodes{$asm_swap}{$cpu}};
		
		$Parser{$tokens}{$cpu}{$parens}{ixiy} = [$asm, @bin];
		$Parser{$tokens}{$cpu}{$parens}{iyix} = [$asm_swap, @bin_swap];
	}
}

open(my $rules, ">:raw", "dev/cpu/cpu_rules.h") or die $!;
for my $tokens (sort keys %Parser) {
	print $rules $tokens, ' @{', "\n";
	print $rules merge_cpu($Parser{$tokens});
	print $rules '}', "\n\n";
}

#------------------------------------------------------------------------------
# build %Tests
#------------------------------------------------------------------------------
my %Tests = ();

for my $asm (sort keys %Opcodes) {
	for my $cpu (sort keys %{$Opcodes{$asm}}) {
		my $bin = join(' ', @{$Opcodes{$asm}{$cpu}});
		
		add_tests($cpu, $asm, $bin);
	}
}

# open tests files
my %fh;
my %pc;
for my $cpu (@CPUS) {
	for my $ixiy ('', '_ixiy') {
		for my $ok ('ok', 'err') {
			next if $ixiy && $ok eq 'err';
			
			my $filename = "dev/cpu/cpu_test_${cpu}${ixiy}_${ok}.asm";
			open($fh{$cpu}{$ixiy}{$ok}, ">:raw", $filename ) or die "$filename: $!";
		}
	}
}

for my $asm (sort keys %Tests) {
	my $asmf = sprintf(" %-31s", $asm);
	for my $cpu (@CPUS) {
		if (exists $Tests{$asm}{$cpu}) {
			for my $ixiy ('', '_ixiy') {
				my $asm1 = $asm;
				if ($ixiy) {
					$asm1 =~ s/\b(ix|iy)/ $1 eq 'ix' ? 'iy' : 'ix' /ge;
				}
				my $bin1 = $Tests{$asm1}{$cpu};
				
				# build jumps to %t
				my $next = ($pc{$cpu}{$ixiy}{ok} || 0) + scalar(split(' ', $bin1));
				$bin1 =~ s/%t %t/ ($next & 0xFF)." ".(($next >> 8) & 0xFF) /e;
				$bin1 =~ s/%t/3/;
				my @bin = split(' ', $bin1);
			
				$fh{$cpu}{$ixiy}{ok}->print($asmf."; ".fmthex(@bin)."\n");
				$pc{$cpu}{$ixiy}{ok} = $next;
			}
		}
		else {
			$fh{$cpu}{''}{err}->print($asmf."; Error\n");
		}
	}
	if (exists $Tests{$asm}{''}) {
		for my $cpu (@CPUS) {
			$fh{$cpu}{''}{err}->print($asmf."; Error\n");
		}
	}
}


#------------------------------------------------------------------------------
# Opcodes
#------------------------------------------------------------------------------
sub add_opc {
	my($cpu, $asm, @bin) = @_;

	# filter invalid opcodes
	return if $asm eq 'ld (hl), (hl)';
	
	add_opc_1($cpu, $asm, @bin);
	
	# expand ixh, ixl, ...
	if ($cpu =~ /^z80/ && $asm =~ /\b[hl]\b/ && $asm !~ /\b(hl|ix|iy|in|out)\b/) {
		(my $asm1 = $asm) =~ s/\b([hl])\b/ix$1/g;
		add_opc_1($cpu, $asm1, $V{ix}, @bin);
		(   $asm1 = $asm) =~ s/\b([hl])\b/iy$1/g;
		add_opc_1($cpu, $asm1, $V{iy}, @bin);
	}
}

sub add_opc_1 {
	my($cpu, $asm, @bin) = @_;

	add_opc_2($cpu, $asm, @bin);
	
	# expand (ix+%d)
	return if $asm =~ /^(ldp|jp)/;
	
	if ($asm =~ /\(hl\)/) {
		(my $asm1 = $asm) =~ s/\(hl\)/(ix+%d)/g;
		add_opc_2($cpu, $asm1, $V{ix}, $bin[0], '%d', @bin[1..$#bin]);
		(   $asm1 = $asm) =~ s/\(hl\)/(iy+%d)/g;
		add_opc_2($cpu, $asm1, $V{iy}, $bin[0], '%d', @bin[1..$#bin]);
	}
}

sub add_opc_2 {
	my($cpu, $asm, @bin) = @_;

	# (ix+%d) -> (ix)
	if ($asm =~ /\+%[du]/) {
		(my $asm1 = $asm) =~ s/\+%[du]//;
		my @bin1 = map {/%[du]/ ? 0 : $_} @bin;
		add_opc_3($cpu, $asm1, @bin1);
	}

	add_opc_3($cpu, $asm, @bin);
}
	
sub add_opc_3 {
	my($cpu, $asm, @bin) = @_;

	add_opc_4($cpu, $asm, @bin);

	return unless $cpu =~ /^r/;
	
	# expand ioi ioe
	my $has_io;
	if (($asm =~ /\((ix|iy|hl|bc|de|%m)/ && $asm !~ /^(ldp|jp)/) ||
		($asm =~ /^(ldi|ldir|ldd|lddr|ldisr|lddsr|lsdr|lsir|lsddr|lsidr)$/)) {
		add_opc_4($cpu, "ioi $asm", $V{ioi}, @bin);
		add_opc_4($cpu, "ioe $asm", $V{ioe}, @bin);
		$has_io++;
	}
	
	# expand altd
	if ($asm =~ /^ (?| ( (?:ld|inc|dec|pop|bool|rlc|rrc|rl|rr|sla|sra|sll|sli|srl|djnz) \s+ 
									(?:a|b|c|d|e|h|l|af|bc|de|hl)) ( $ | \b [^'] .*)
					 | ( (?:add|adc|sub|sbc|and|xor|or|cpl|neg) \s+ (?:a|hl) )(,.*)
					 | ( (?:ccf|scf) \s+ f)(,.*)
					 | ( (?:rlca|rrca|rla|rra)) (.*)
					 | ( (?:res|set) \s+ %c \s* , \s* (?:a|b|c|d|e|h|l)) ( $ | \b [^'] .*)
				   ) $/x) {
		if ($has_io) {
			add_opc_4($cpu, "$1'$2", $V{altd}, @bin);
			add_opc_4($cpu, "ioi $1'$2", $V{ioi}, $V{altd}, @bin);
			add_opc_4($cpu, "ioe $1'$2", $V{ioe}, $V{altd}, @bin);
			
			add_opc_4($cpu, "altd $1$2", $V{altd}, @bin);
			add_opc_4($cpu, "altd ioi $1$2", $V{altd}, $V{ioi}, @bin);
			add_opc_4($cpu, "altd ioe $1$2", $V{altd}, $V{ioe}, @bin);
			add_opc_4($cpu, "ioi altd $1$2", $V{ioi}, $V{altd}, @bin);
			add_opc_4($cpu, "ioe altd $1$2", $V{ioe}, $V{altd}, @bin);
		}
		else {
			add_opc_4($cpu, "$1'$2", $V{altd}, @bin);
			add_opc_4($cpu, "altd $1$2", $V{altd}, @bin);
		}
	}
	elsif ($asm =~ /^ (?| ( (?:add|adc|sub|sbc|and|xor|or) \s+ [^,]+ )
						| ( (?:and|or) \s+ (ix|iy) \s* , .* )
						| ( (?:inc|dec) \s+ \( .* )
						| ( (?:bool|rr) \s+ (ix|iy) .* )
					    | ( (?:cp|cpl|bit|djnz) \s+ .*) 
						| ( (?:rlc|rrc|rl|rr|sla|sra|sll|sli|srl) \s+ \( .*)
					  ) $/x) {
		if ($has_io) {
			add_opc_4($cpu, "altd $1", $V{altd}, @bin);
			add_opc_4($cpu, "altd ioi $1", $V{altd}, $V{ioi}, @bin);
			add_opc_4($cpu, "altd ioe $1", $V{altd}, $V{ioe}, @bin);
			add_opc_4($cpu, "ioi altd $1", $V{ioi}, $V{altd}, @bin);
			add_opc_4($cpu, "ioe altd $1", $V{ioe}, $V{altd}, @bin);
		}
		else {
			add_opc_4($cpu, "altd $1", $V{altd}, @bin);
		}
	}
}

sub add_opc_4 {
	my($cpu, $asm, @bin) = @_;

	if ($Opcodes{$asm}{$cpu}) {
		my $old = fmthex(@{$Opcodes{$asm}{$cpu}});
		my $new = fmthex(@bin);
		if ($old ne $new) {
			die "$cpu: $asm: ($old) or ($new)?";
		}
	}
	else {
		say sprintf("%-8s%-24s%s", $cpu, $asm, fmthex(@bin));

		$Opcodes{$asm}{$cpu} = \@bin;
	}
}

#------------------------------------------------------------------------------
# Parser
#------------------------------------------------------------------------------
sub parser_tokens {
	local($_) = @_;
	my @tokens = ();
	
	while (!/\G \z 				/gcx) {
		if (/\G \s+ 			/gcx) {}
		elsif (/\G \( (\w+) 	/gcx) { push @tokens, "_TK_IND_".uc($1); }
		elsif (/\G , 			/gcx) { push @tokens, "_TK_COMMA"; }
		elsif (/\G \) 			/gcx) { push @tokens, "_TK_RPAREN"; }
		elsif (/\G \( %[nm] \)	/gcx) { push @tokens, "expr"; }
		elsif (/\G \+ %[du]		/gcx) { push @tokens, "expr"; }
		elsif (/\G    %[snmMj]	/gcx) { push @tokens, "expr"; }
		elsif (/\G    %[c]		/gcx) { push @tokens, "const_expr"; }
		elsif (/\G    (\w+)	'	/gcx) { push @tokens, "_TK_".uc($1)."1"; }
		elsif (/\G    (\w+)		/gcx) { push @tokens, "_TK_".uc($1); }
		else { die "$_ ; ", substr($_, pos($_)||0) }
	}
	return join(' ', ('| label?', @tokens, "_TK_NEWLINE"));
}

sub parse_code {
	my($cpu, $asm, @bin) = @_;
	my @code;
	
	# store prefixes
	if ($cpu =~ /^r/) {
		while (@bin && $bin[0] =~ /^\d+$/ &&
				($bin[0] == $V{altd} ||
				 $bin[0] == $V{ioi} ||
				 $bin[0] == $V{ioe})) {
			push @code, "DO_stmt(0x".fmthex(shift @bin).");"
		}
	}
	
	# check for argument type
	my($stmt, $extra_arg) = ("", "");
	my $bin = join(' ', @bin);
	
	if ($bin =~ s/ \@(\w+)//) {
		my $func = $1;
		push @code, 
			"DO_STMT_LABEL();",
			"add_call_emul_func(\"$func\");";
	}
	elsif ($asm =~ /^rst/) {
		push @code, 
			"DO_STMT_LABEL();",
			"if (expr_error) { error_expected_const_expr(); } else {",
			"if (expr_value > 0 && expr_value < 8) expr_value *= 8;",
			"switch (expr_value) {",
			"case 0x00: case 0x08: case 0x30:",
			"  if (opts.cpu & CPU_RABBIT)",
			"    DO_stmt(0xCD0000 + (expr_value << 8));",
			"  else",
			"    DO_stmt(0xC7 + expr_value);",
			"  break;",
			"case 0x10: case 0x18: case 0x20: case 0x28: case 0x38:",
			"  DO_stmt(0xC7 + expr_value); break;",
			"default: error_int_range(expr_value);",
			"}}";
		my $code = join("\n", @code);
		return $code;
	}
	elsif ($asm =~ /^mmu %c, %n/) {
		push @code, 
			"DO_STMT_LABEL();",
			"if (expr_error) { error_expected_const_expr(); } else {",
			"if (expr_value < 0 || expr_value > 7) error_int_range(expr_value);",
			"DO_stmt_n(0xED9150 + expr_value);}";
		my $code = join("\n", @code);
		return $code;
	}
	elsif ($asm =~ /^mmu %c, a/) {
		push @code, 
			"DO_STMT_LABEL();",
			"if (expr_error) { error_expected_const_expr(); } else {",
			"if (expr_value < 0 || expr_value > 7) error_int_range(expr_value);",
			"DO_stmt(0xED9250 + expr_value);}";
		my $code = join("\n", @code);
		return $code;
	}
	elsif ($bin =~ s/ %d %n$//) {
		$stmt = "DO_stmt_idx_n";
	}
	elsif ($bin =~ s/ %n %n$//) {
		$stmt = "DO_stmt_n_n";
	}
	elsif ($bin =~ s/ %n$//) {
		$stmt = "DO_stmt_n";
	}
	elsif ($bin =~ s/ %u$//) {
		$stmt = "DO_stmt_n";
	}
	elsif ($bin =~ s/ %s$//) {
		$stmt = "DO_stmt_d";
	}
	elsif ($bin =~ /%t %t/) {
		push @code,
			"DO_STMT_LABEL();",
			"Expr *target_expr = pop_expr(ctx);",
			"const char *end_label = autolabel();",
			"Expr *end_label_expr = parse_expr(end_label);",
			"add_opcode_nn(0x".fmthex($bin[0]).", end_label_expr);",	# jump over
			"add_opcode_nn(0x".fmthex($bin[3]).", target_expr);",		# call
			"asm_LABEL_offset(end_label, 6);";
		my $code = join("\n", @code);
		return $code;
	}
	elsif ($bin =~ s/ %m %m$//) {
		$stmt = "DO_stmt_nn";
	}
	elsif ($bin =~ s/ %M %M$//) {
		$stmt = "DO_stmt_NN";
	}
	elsif ($bin =~ s/ %j$//) {
		$stmt = "DO_stmt_jr";
	}
	elsif ($bin =~ s/%c\((.*?)\)/expr_value/) {
		my @values = eval($1); die "$cpu, $asm, @bin, $1" if $@;
		$bin =~ s/%c/expr_value/g;		# replace all other %c in bin
		push @code,
			"if (expr_error) { error_expected_const_expr(); } else {",
			"switch (expr_value) {",
			join(" ", map {"case $_:"} @values)." break;",
			"default: error_int_range(expr_value);",
			"}}";
			
		if ($bin =~ s/ %d// || $bin =~ s/%d //) {
			$stmt = "DO_stmt_idx";
		} 
		else {
			$stmt = "DO_stmt";
		}
	}
	elsif ($bin =~ s/ %d//) {
		$stmt = "DO_stmt_idx";
	}
	else {
		$stmt = "DO_stmt";
	}

	# build statement - need to leave expressions for C compiler
	@bin = split(' ', $bin);
	my @expr;
	for (@bin) {
		if (/[+*?]/) {
			my $offset = 0;
			if (s/^(\d+)\+//) {
				$offset = $1;
			}
			$_ =~ s/\b(\d+)\b/ $1 < 10 ? $1 : "0x".fmthex($1) /ge;
			push @expr, $_;
			$_ = fmthex($offset);
		}
		else {
			push @expr, undef;
			$_ = eval($_); die "$cpu, $asm, @bin, $_" if $@;
			$_ = fmthex($_);
		}
	}
	
	my $opc = "0x".join('', @bin);
	for (0..$#expr) {
		next unless defined $expr[$_];
		my $bytes_shift = scalar(@bin) - $_ - 1;
		$opc .= '+(('.($expr[$_]).')';
		$opc .= ' << '.($bytes_shift * 8) if $bytes_shift;
		$opc .= ')';
	}
	$stmt and push @code, $stmt."(".$opc.$extra_arg.");";
	
	my $code = join("\n", @code);
	return $code;
}

sub merge_cpu {
	my($t) = @_;
	my $ret = '';
	my %code;
	
	my $last_code;
	for my $cpu (@CPUS) {
		if (exists $t->{$cpu}) {
			my $code = merge_parens($cpu, $t->{$cpu});
			$code{$code}{$cpu}++;
			$last_code = $code;
		}
	}
	
	if (scalar(keys %code) == 1 && 
	    scalar(keys %{$code{$last_code}}) == scalar(@CPUS)) {
		# no variants
		$ret .= $last_code."\n";
	}
	else {
		# variants per CPU
		$ret .= "switch (opts.cpu) {\n";
		for my $code (sort keys %code) {
			for my $cpu (sort keys %{$code{$code}}) {
				$ret .= "case CPU_".uc($cpu).": ";
			}
			$ret .= "\n$code\nbreak;\n"
		}
		$ret .= "default: error_illegal_ident(); }\n";
	}
	
	return $ret;
}

sub merge_parens {
	my($cpu, $t) = @_;
	my $ret = '';
	
	if ($t->{no_expr}) {
		die if $t->{expr_no_parens} || $t->{expr_in_parens};
		return merge_ixiy($cpu, $t->{no_expr});
	}
	elsif (!$t->{expr_no_parens} && !$t->{expr_in_parens}) {
		die;
	}
	elsif (!$t->{expr_no_parens} && $t->{expr_in_parens}) {
		return "if (!expr_in_parens) return false;\n".
				merge_ixiy($cpu, $t->{expr_in_parens});			
	}
	elsif ($t->{expr_no_parens} && !$t->{expr_in_parens}) {
		return "if (expr_in_parens) warn_expr_in_parens();\n".
				merge_ixiy($cpu, $t->{expr_no_parens});
	}
	elsif ($t->{expr_no_parens} && $t->{expr_in_parens}) {
		my($common, $in_parens, $no_parens) = 
			extract_common(merge_ixiy($cpu, $t->{expr_in_parens}),
						   merge_ixiy($cpu, $t->{expr_no_parens}));
		return $common.
				"if (expr_in_parens) { $in_parens } else { $no_parens }";
	}
	else {
		die;
	}
}

sub merge_ixiy {
	my($cpu, $t) = @_;
	
	my $ixiy = parse_code($cpu, @{$t->{ixiy}});
	my $iyix = parse_code($cpu, @{$t->{iyix}});
	
	if ($ixiy eq $iyix) {
		return $ixiy;
	}
	else {
		(my $common, $ixiy, $iyix) = extract_common($ixiy, $iyix);
		return $common.
				"if (!opts.swap_ix_iy) { $ixiy } else { $iyix }";
	}
}

sub extract_common {
	my($a, $b) = @_;
	my $common = '';
	
	while ($a =~ /(.*?[;}])/s && 
			substr($a, 0, length($1)) eq
			substr($b, 0, length($1)) ) {
		$common .= $1;
		
		$a = substr($a, length($&));
		$b = substr($b, length($&));
	}
	$common .= "\n" if $common;
	
	return ($common, $a, $b);
}

#------------------------------------------------------------------------------
# Tests
#------------------------------------------------------------------------------
sub add_tests {
	my($cpu, $asm, $bin) = @_;

	if ($asm =~ /%s/) {
		add_tests($cpu, replace($asm, '%s', 127), replace($bin, '%s', 0x7F));
		add_tests($cpu, replace($asm, '%s', -128), replace($bin, '%s', 0x80));
	}
	elsif ($asm =~ /%n/) {
		add_tests($cpu, replace($asm, '%n', 255), replace($bin, '%n', 0xFF));
		add_tests($cpu, replace($asm, '%n', 127), replace($bin, '%n', 0x7F));
		add_tests($cpu, replace($asm, '%n', -128), replace($bin, '%n', 0x80));
	}
	elsif ($asm =~ /%m/) {
		add_tests($cpu, replace($asm, '%m', 65535), replace($bin, '%m %m', 0xFF." ".0xFF));
		add_tests($cpu, replace($asm, '%m', 32767), replace($bin, '%m %m', 0xFF." ".0x7F));
		add_tests($cpu, replace($asm, '%m',-32768), replace($bin, '%m %m', 0x00." ".0x80));
	}
	elsif ($asm =~ /%M/) {
		add_tests($cpu, replace($asm, '%M', 65535), replace($bin, '%M %M', 0xFF." ".0xFF));
		add_tests($cpu, replace($asm, '%M', 32767), replace($bin, '%M %M', 0x7F." ".0xFF));
		add_tests($cpu, replace($asm, '%M',-32768), replace($bin, '%M %M', 0x80." ".0x00));
	}
	elsif ($asm =~ /%j/) {
		add_tests($cpu, replace($asm, '%j', "ASMPC"), replace($bin, '%j', 0xFE));
	}
	elsif ($asm =~ /^rst %c/) {		# special case
		for my $div (1, 8) {
			if ($cpu =~ /^r/) {
				add_tests($cpu, replace($asm, '%c', 0x00/$div), join(' ', 0xCD, 0x00, 0x00));
				add_tests($cpu, replace($asm, '%c', 0x08/$div), join(' ', 0xCD, 0x08, 0x00));
				add_tests($cpu, replace($asm, '%c', 0x30/$div), join(' ', 0xCD, 0x30, 0x00));
			}
			else {
				add_tests($cpu, replace($asm, '%c', 0x00/$div), join(' ', 0xC7));
				add_tests($cpu, replace($asm, '%c', 0x08/$div), join(' ', 0xCF));
				add_tests($cpu, replace($asm, '%c', 0x30/$div), join(' ', 0xF7));
			}
			add_tests($cpu, replace($asm, '%c', 0x10/$div), join(' ', 0xD7));
			add_tests($cpu, replace($asm, '%c', 0x18/$div), join(' ', 0xDF));
			add_tests($cpu, replace($asm, '%c', 0x20/$div), join(' ', 0xE7));
			add_tests($cpu, replace($asm, '%c', 0x28/$div), join(' ', 0xEF));
			add_tests($cpu, replace($asm, '%c', 0x38/$div), join(' ', 0xFF));
		}
		for my $invalid (-1, 9..15, 17..23, 25..31, 33..39, 41..47, 49..55, 57..64) {
			add_tests('', replace($asm, '%c', $invalid), '');
		}
	}
	elsif ($asm =~ /%c/) {
		$bin =~ s/%c\((.*?)\)/%c/ or die $bin;
		my @values = eval($1); die "$cpu, $asm, $bin, $1" if $@;
		my($min, $max) = ($values[0], $values[-1]);
		for (@values) {
			my @bin = split(' ', replace($bin, '%c', $_));
			for (@bin) {
				$_ = eval($_) if /[+*?]/; die $@ if $@;
			}
			add_tests($cpu, replace($asm, '%c', $_), join(' ', @bin));
			$min = $_ if $_ < $min;
			$max = $_ if $_ > $max;
		}
		add_tests('', replace($asm, '%c', $min-1), '');
		add_tests('', replace($asm, '%c', $max+1), '');
	}
	elsif ($asm =~ /%d/) {
		add_tests($cpu, replace($asm, qr/\+%d/, "+127"), replace($bin, '%d', 0x7F));
		add_tests($cpu, replace($asm, qr/\+%d/, "-128"), replace($bin, '%d', 0x80));
	}
	elsif ($asm =~ /%u/) {
		add_tests($cpu, replace($asm, qr/\+%u/, "+255"), replace($bin, '%u', 0xFF));
		add_tests($cpu, replace($asm, qr/\+%u/, "+0"  ), replace($bin, '%u', 0x00));
	}
	else {
		$Tests{$asm}{$cpu} = $bin;
	}
}

sub fmthex {
	return join(' ', map {/\D/ ? $_ : sprintf('%02X', $_)} @_);
}

sub replace {
	my($text, $find, $replace) = @_;
	$text =~ s/$find/$replace/g;
	return $text;
}

