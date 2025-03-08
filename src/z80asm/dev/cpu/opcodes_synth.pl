#------------------------------------------------------------------------------
# Synthetic opcodes
#------------------------------------------------------------------------------

for my $cpu (Opcode->cpus) {

	# Rabbit prefixes
	my @rabbit_prefixes = ('');
	if ($cpu =~ /^r\dk/) {
		@rabbit_prefixes = ('', 
							'altd ', 'altd ioi ', 'altd ioe ', 
							'ioi ', 'ioi altd ',
							'ioe ', 'ioe altd ');
	}

	# ez80 suffixes
	my @ez80_suffixes = ('');
	if ($cpu =~ /^ez80/) {
		@ez80_suffixes = ('', '.s', '.l', '.il', '.is', '.sil', '.lil', '.sis', '.lis');
	} 

	#--------------------------------------------------------------------------
	# Jumps
	#--------------------------------------------------------------------------

	# JR in intel
	if ($cpu =~ /^(8080|8085)/) {
		add_synth($cpu, "jr %j", "jp %m");
		for my $flag ('nz', 'z', 'nc', 'c') {
			add_synth($cpu, "jr $flag, %j", "jp $flag, %m");
		}
		add_synth($cpu, "djnz %j", "dec b", "jp nz, %m");
		add_synth($cpu, "djnz b, %j", "dec b", "jp nz, %m");
	}
	
	# JP|CALL|RET EQ, NN
	add_synth($cpu, "jeq %m", "jz %m");
	add_synth($cpu, "j_eq %m", "jz %m");
	add_synth($cpu, "jp eq, %m", "jp z, %m");
	add_synth($cpu, "jmp eq, %m", "jp z, %m");
	add_synth($cpu, "jr eq, %j", "jr z, %j");
	add_synth($cpu, "ceq %m", "cz %m");
	add_synth($cpu, "c_eq %m", "cz %m");
	for my $suf (@ez80_suffixes) {
		add_synth($cpu, "call$suf eq, %m", "call$suf z, %m");
		add_synth($cpu, "ret$suf eq", "ret$suf z");
	}
	add_synth($cpu, "req", "rz");
	add_synth($cpu, "r_eq", "rz");

	# JP|CALL|RET NE, NN
	add_synth($cpu, "jne %m", "jnz %m");
	add_synth($cpu, "j_ne %m", "jnz %m");
	add_synth($cpu, "jp ne, %m", "jp nz, %m");
	add_synth($cpu, "jmp ne, %m", "jp nz, %m");
	add_synth($cpu, "jr ne, %j", "jr nz, %j");
	add_synth($cpu, "cne %m", "cnz %m");
	add_synth($cpu, "c_ne %m", "cnz %m");
	for my $suf (@ez80_suffixes) {
		add_synth($cpu, "call$suf ne, %m", "call$suf nz, %m");
		add_synth($cpu, "ret$suf ne", "ret$suf nz");
	}
	add_synth($cpu, "rne", "rnz");
	add_synth($cpu, "r_ne", "rnz");

	# JP|CALL|RET GEU, NN
	add_synth($cpu, "jgeu %m", "jnc %m");
	add_synth($cpu, "j_geu %m", "jnc %m");
	add_synth($cpu, "jp geu, %m", "jp nc, %m");
	add_synth($cpu, "jmp geu, %m", "jp nc, %m");
	add_synth($cpu, "jr geu, %j", "jr nc, %j");
	add_synth($cpu, "cgeu %m", "cnc %m");
	add_synth($cpu, "c_geu %m", "cnc %m");
	for my $suf (@ez80_suffixes) {
		add_synth($cpu, "call$suf geu, %m", "call$suf nc, %m");
		add_synth($cpu, "ret$suf geu", "ret$suf nc");
	}
	add_synth($cpu, "rgeu", "rnc");
	add_synth($cpu, "r_geu", "rnc");

	# JP|CALL|RET LTU, NN
	add_synth($cpu, "jltu %m", "jc %m");
	add_synth($cpu, "j_ltu %m", "jc %m");
	add_synth($cpu, "jp ltu, %m", "jp c, %m");
	add_synth($cpu, "jmp ltu, %m", "jp c, %m");
	add_synth($cpu, "jr ltu, %j", "jr c, %j");
	add_synth($cpu, "cltu %m", "cc %m");
	add_synth($cpu, "c_ltu %m", "cc %m");
	for my $suf (@ez80_suffixes) {
		add_synth($cpu, "call$suf ltu, %m", "call$suf c, %m");
		add_synth($cpu, "ret$suf ltu", "ret$suf c");
	}
	add_synth($cpu, "rltu", "rc");
	add_synth($cpu, "r_ltu", "rc");
	
	# JP|CALL|RET GTU, NN
	add_synth($cpu, "jgtu %m", "jz %t", "jnc %m");
	add_synth($cpu, "j_gtu %m", "jz %t", "jnc %m");
	add_synth($cpu, "jp gtu, %m", "jr z, %t", "jp nc, %m");
	add_synth($cpu, "jmp gtu, %m", "jr z, %t", "jp nc, %m");
	add_synth($cpu, "jr gtu, %j", "jr z, %t", "jr nc, %j");
	add_synth($cpu, "cgtu %m", "jr z, %t", "call nc, %m");
	add_synth($cpu, "c_gtu %m", "jr z, %t", "call nc, %m");
	for my $suf (@ez80_suffixes) {
		add_synth($cpu, "call$suf gtu, %m", "jr z, %t", "call$suf nc, %m");
		add_synth($cpu, "ret$suf gtu", "jr z, %t", "ret$suf nc");
	}
	add_synth($cpu, "rgtu", "jr z, %t", "rnc");
	add_synth($cpu, "r_gtu", "jr z, %t", "rnc");

	# JP|CALL|RET LEU, NN
	add_synth($cpu, "jleu %m", "jz %m", "jc %m");
	add_synth($cpu, "j_leu %m", "jz %m", "jc %m");
	add_synth($cpu, "jp leu, %m", "jp z, %m", "jp c, %m");
	add_synth($cpu, "jmp leu, %m", "jp z, %m", "jp c, %m");
	add_synth($cpu, "jr leu, %j", "jr z, %j", "jr c, %j");
	for my $suf (@ez80_suffixes) {
		# ez80 size of call instuction
		my $call_size = 3;
		my $call_opcode = get_opcode($cpu, "call$suf %m");
		if ($call_opcode) {
			$call_size = scalar($call_opcode->bytes);
		}
	
		add_synth($cpu, "cleu %m", "jr z, %t$call_size", "jr nc, %t", "call %m");
		add_synth($cpu, "c_leu %m", "jr z, %t$call_size", "jr nc, %t", "call %m");
		add_synth($cpu, "call$suf leu, %m", "jr z, %t$call_size", "jr nc, %t", "call$suf %m");
		add_synth($cpu, "ret$suf leu", "ret$suf z", "ret$suf c");
	}
	add_synth($cpu, "rleu", "rz", "rc");
	add_synth($cpu, "r_leu", "rz", "rc");

	# JP|CALL|RET NV, NN
	if ($cpu =~ /^(r4k|r5k)/) {		# overflow and parity are different flags
	}
	else {
		add_synth($cpu, "jnv %m", "jpo %m");
		add_synth($cpu, "j_nv %m", "jpo %m");
		add_synth($cpu, "jp nv, %m", "jp po, %m");
		add_synth($cpu, "jmp nv, %m", "jp po, %m");
		add_synth($cpu, "cnv %m", "cpo %m");
		add_synth($cpu, "c_nv %m", "cpo %m");
		for my $suf (@ez80_suffixes) {
			add_synth($cpu, "call$suf nv, %m", "call$suf po, %m");
			add_synth($cpu, "ret$suf nv", "ret$suf po");
		}
		add_synth($cpu, "rnv", "rpo");
		add_synth($cpu, "r_nv", "rpo");
	}

	# JP|CALL|RET V, NN
	if ($cpu =~ /^(r4k|r5k)/) {		# overflow and parity are different flags
	}
	else {
		add_synth($cpu, "jv %m", "jpe %m");
		add_synth($cpu, "j_v %m", "jpe %m");
		add_synth($cpu, "jp v, %m", "jp pe, %m");
		add_synth($cpu, "jmp v, %m", "jp pe, %m");
		add_synth($cpu, "cv %m", "cpe %m");
		add_synth($cpu, "c_v %m", "cpe %m");
		for my $suf (@ez80_suffixes) {
			add_synth($cpu, "call$suf v, %m", "call$suf pe, %m");
			add_synth($cpu, "ret$suf v", "ret$suf pe");
		}
		add_synth($cpu, "rv", "rpe");
		add_synth($cpu, "r_v", "rpe");
	}		
	
	# CALL (HL|IXY)
	for my $rp ('hl') {
		add_emul($cpu, "call ($rp)", "__z80asm__call_$rp");
	}
	if (get_opcode($cpu, "ld ix, %m")) {
		for my $rp ('ix', 'iy') {
			add_emul($cpu, "call ($rp)", "__z80asm__call_$rp");
		}
	}
	
	# JP (rp)
	for my $rp ('bc', 'de') {
		for my $jump ('jp', 'jmp') {
			add_synth($cpu, "$jump ($rp)", "push $rp", "ret");
		}
	}
	
	#--------------------------------------------------------------------------
	# Exchange group
	#--------------------------------------------------------------------------

    for my $asm ("ex af', af", "ex af, af") {
        add_synth($cpu, $asm, "ex af, af'");
    }
    
	for my $asm ("ex bc, hl", "ex hl, bc") {
		add_synth($cpu, $asm, "push hl : push bc : pop hl : pop bc");
	}
	
	add_synth($cpu, "ex hl, de", "ex de, hl");


	if ($cpu !~ /^(8080|8085)/) {
		add_emul($cpu, "ex (sp), hl", "__z80asm__ex_sp_hl");
	}
	
	add_synth($cpu, "xthl", "ex (sp), hl");
	
	#--------------------------------------------------------------------------
	# 16-bit load
	#--------------------------------------------------------------------------

	# LD rp1, rp2
	for my $rp1 ('bc', 'de', 'hl') {
		my($h1, $l1) = split //, $rp1;
		for my $rp2 ('bc', 'de', 'hl') {
			next if $rp1 eq $rp2;
			my($h2, $l2) = split //, $rp2;
			add_synth($cpu, "ld $rp1, $rp2", "ld $h1, $h2", "ld $l1, $l2");
		}
	}

	# LD BC|DE|HL, IX / LD IX, BC|DE|HL
	for my $rp ('bc', 'de') {
		my($h, $l) = split //, $rp;
		for my $x ('ix', 'iy') {
			add_synth($cpu, "ld $rp, $x", "ld $h, ${x}h", "ld $l, ${x}l");
			add_synth($cpu, "ld $x, $rp", "ld ${x}h, $h", "ld ${x}l, $l");
		}
	}

	# all the others via push-pop
	for my $rp1 ('bc', 'de', 'hl', 'ix', 'iy') {
		for my $rp2 ('bc', 'de', 'hl', 'ix', 'iy') {
			next if $rp1 eq $rp2;
			add_synth($cpu, "ld $rp1, $rp2", "push $rp2", "pop $rp1");
		}
	}

	#--------------------------------------------------------------------------
	# 16-bit load plus 8-bit offset
	#--------------------------------------------------------------------------

	# LD DE, HL+u
	for my $asm ("ldhi %n", "adi hl, %n", "ld de, hl+%u") {
		my($var) = $asm =~ /(%\w)/;
		add_synth($cpu, $asm, 
							"push hl", 
							"ld de, 0:$var", "add hl, de", "ex de, hl", 
							"pop hl");
	}

	# LD DE, SP+u
	for my $asm ("ldsi %n", "adi sp, %n", "ld de, sp+%u") {
		my($var) = $asm =~ /(%\w)/;
		add_synth($cpu, $asm, 
							"ex de, hl", 
							"ld hl, 0:$var", "add hl, sp", 
							"ex de, hl");
	}
	add_synth($cpu, "ld de, sp", 
							"ex de, hl", 
							"ld hl, 0x0000", "add hl, sp", 
							"ex de, hl");
	
	# LD HL, SP+s
    if ($cpu =~ /^8085/) {
        add_synth($cpu, "ld hl, sp+%u", 
							"ex de, hl", 
							"ld de, sp+%u", 
							"ex de, hl");
        add_synth($cpu, "ld hl, sp", 
							"ex de, hl", 
							"ld de, sp", 
							"ex de, hl");
    }
    else {
        add_synth($cpu, "ld hl, sp+%s", 
                            "ld hl, 0:%s", "add hl, sp");
        add_synth($cpu, "ld hl, sp", 
                            "ld hl, 0x0000", "add hl, sp");
    }
	
	#--------------------------------------------------------------------------
	# 16-bit memory load
	#--------------------------------------------------------------------------

	if ($cpu !~ /^gbz80/) {
		add_synth($cpu, "ld bc, (%m)", 
							"push hl", "ld hl, (%m)", "ld bc, hl", "pop hl");
		add_synth($cpu, "ld (%m), bc", 
							"push hl", "ld hl, bc", "ld (%m), hl", "pop hl");
		
		add_synth($cpu, "ld de, (%m)", 
							"ex de, hl", "ld hl, (%m)", "ex de, hl");
		add_synth($cpu, "ld (%m), de", 
							"ex de, hl", "ld (%m), hl", "ex de, hl");
		
		# LD (NN), SP - account for the pushed hl on the stack
		add_synth($cpu, "ld (%m), sp", 
							"push hl",
							"ld hl, 0x0002", "add hl, sp", "ld (%m), hl",
							"pop hl");
	}
	
	#--------------------------------------------------------------------------
	# 16-bit indirect load
	#--------------------------------------------------------------------------

	# LD (HL), BC|DE
	for my $rp ('bc', 'de') {
		my($h, $l) = split //, $rp;
		add_synth($cpu, "ld (hl), $rp", 
							"ld (hl), $l", "inc hl", "ld (hl), $h", "dec hl");
		add_synth($cpu, "ld (hl+), $rp", 
							"ld (hl), $l", "inc hl", "ld (hl), $h", "inc hl");
		add_synth($cpu, "ldi (hl), $rp", 
							"ld (hl), $l", "inc hl", "ld (hl), $h", "inc hl");
	}
	
	# LD (HL), HL
	add_synth($cpu, "ld (hl), hl",
						"push af", 
						"ld a, h", "ld (hl), l", "inc hl", "ld (hl), a",
						"pop af", "dec hl");
	if ($cpu !~ /^r\dk/) {	# not yet for Rabbits
		add_synth($cpu, "ld (hl+), hl",
							"push af", 
							"ld a, h", "ld (hl), l", "inc hl", "ld (hl), a",
							"pop af", "inc hl");
		add_synth($cpu, "ldi (hl), hl",
							"push af", 
							"ld a, h", "ld (hl), l", "inc hl", "ld (hl), a",
							"pop af", "inc hl");
	}

	# LD (HL), IX|IY
	for my $x ('ix', 'iy') {
		add_synth($cpu, "ld (hl), $x", 
							"push de",
							"push $x", "pop de",
							"ld (hl), e", "inc hl", "ld (hl), d", "dec hl",
							"pop de");
		add_synth($cpu, "ld (hl+), $x", 
							"push de",
							"push $x", "pop de",
							"ld (hl), e", "inc hl", "ld (hl), d", "inc hl",
							"pop de");
		add_synth($cpu, "ldi (hl), $x", 
							"push de",
							"push $x", "pop de",
							"ld (hl), e", "inc hl", "ld (hl), d", "inc hl",
							"pop de");
	}

	# LD (IX+d), BC|DE|HL|IX|IY
	for my $x ('ix', 'iy') {
		add_synth($cpu, "ld ($x+%d), bc", "ld ($x+%d), c", "ld ($x+%D), b");
		add_synth($cpu, "ld ($x), bc", "ld ($x), c", "ld ($x+0x01), b");

		add_synth($cpu, "ld ($x+%d), de", "ld ($x+%d), e", "ld ($x+%D), d");
		add_synth($cpu, "ld ($x), de", "ld ($x), e", "ld ($x+0x01), d");

		if ($cpu !~ /^r\dk/) {	# not yet for Rabbits
			add_synth($cpu, "ld ($x+%d), hl", "ld ($x+%d), l", "ld ($x+%D), h");
			add_synth($cpu, "ld ($x), hl", "ld ($x), l", "ld ($x+0x01), h");
		}

		for my $x1 ('ix', 'iy') {
			add_synth($cpu, "ld ($x+%d), $x1",
					  "push $x1", "ex (sp), hl",
					  "ld ($x+%d), l", "ld ($x+%D), h",
					  "ex (sp), hl", "pop $x1");
			add_synth($cpu, "ld ($x), $x1",
					  "push $x1", "ex (sp), hl",
					  "ld ($x), l", "ld ($x+0x01), h",
					  "ex (sp), hl", "pop $x1");
		}
	}

	# LD HL, (HL)
	add_synth($cpu, "ld hl, (hl)",
						"push af", 
						"ld a, (hl)", "inc hl", "ld h, (hl)", "ld l, a",
						"pop af");
	
	# LD IX, (HL)
	for my $x ('ix', 'iy') {
		add_synth($cpu, "ld $x, (hl)",
						"push de",
						"ld e, (hl)", "inc hl", "ld d, (hl)", "dec hl",
						"push de", "pop $x",
						"pop de");
		add_synth($cpu, "ld $x, (hl+)",
						"push de",
						"ld e, (hl)", "inc hl", "ld d, (hl)", "inc hl",
						"push de", "pop $x",
						"pop de");
		add_synth($cpu, "ldi $x, (hl)",
						"push de",
						"ld e, (hl)", "inc hl", "ld d, (hl)", "inc hl",
						"push de", "pop $x",
						"pop de");
	}

	# LD BC|DE, (HL)
	for my $rp ('bc', 'de') {
		my($h, $l) = split //, $rp;
		add_synth($cpu, "ld $rp, (hl)", 
							"ld $l, (hl)", "inc hl", "ld $h, (hl)", "dec hl");
		add_synth($cpu, "ld $rp, (hl+)", 
							"ld $l, (hl)", "inc hl", "ld $h, (hl)", "inc hl");
		add_synth($cpu, "ldi $rp, (hl)", 
							"ld $l, (hl)", "inc hl", "ld $h, (hl)", "inc hl");
	}
	
	# LD HL, (DE)
	if ($cpu !~ /^gbz80/) {		# gameboy lacks ex de, hl
		add_synth($cpu, "ld hl, (de)", 
							"ex de, hl",
							"ld e, (hl)", "inc hl", "ld d, (hl)", "dec hl",
							"ex de, hl");
		add_synth($cpu, "lhlx", "ld hl, (de)");
		add_synth($cpu, "lhlde", "ld hl, (de)");
	}
	
	# LD BC|DE|HL|IX, (IX+d)
	for my $x ('ix', 'iy') {
		add_synth($cpu, "ld bc, ($x+%d)", "ld c, ($x+%d)", "ld b, ($x+%D)");
		add_synth($cpu, "ld bc, ($x)", "ld c, ($x)", "ld b, ($x+0x01)");

		add_synth($cpu, "ld de, ($x+%d)", "ld e, ($x+%d)", "ld d, ($x+%D)");
		add_synth($cpu, "ld de, ($x)", "ld e, ($x)", "ld d, ($x+0x01)");

		add_synth($cpu, "ld hl, ($x+%d)", "ld l, ($x+%d)", "ld h, ($x+%D)");
		add_synth($cpu, "ld hl, ($x)", "ld l, ($x)", "ld h, ($x+0x01)");

		for my $x1 ('ix', 'iy') {
			add_synth($cpu, "ld $x1, ($x+%d)",
					  "push $x1", "ex (sp), hl",
					  "ld l, ($x+%d)", "ld h, ($x+%D)",
					  "ex (sp), hl", "pop $x1");
			add_synth($cpu, "ld $x1, ($x)",
					  "push $x1", "ex (sp), hl",
					  "ld l, ($x)", "ld h, ($x+0x01)",
					  "ex (sp), hl", "pop $x1");
		}
	}

	# LD (DE), HL
	if ($cpu !~ /^gbz80/) {		# gameboy lacks ex de, hl
		add_synth($cpu, "ld (de), hl", 
							"ex de, hl",
							"ld (hl), e", "inc hl", "ld (hl), d", "dec hl",
							"ex de, hl");
		add_synth($cpu, "shlx", "ld (de), hl");
		add_synth($cpu, "shlde", "ld (de), hl");
	}
	
	#--------------------------------------------------------------------------
	# ALU
	#--------------------------------------------------------------------------

	# CLR
	for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a', 
			   'ixh', 'ixl', 'iyh', 'iyl') {
		for my $pref (@rabbit_prefixes) {
			for my $tick ("", "'") {
				add_synth($cpu, "${pref}clr $r$tick", "${pref}ld $r$tick, 0x00");
			}
		}			
	}
	
	for my $r ('(hl)') {
		for my $pref (@rabbit_prefixes) {
			add_synth($cpu, "${pref}clr $r", "${pref}ld $r, 0x00"); 
		}
	}
	
	for my $x ('ix', 'iy') {
		for my $pref (@rabbit_prefixes) {
			add_synth($cpu, "${pref}clr ($x)", "${pref}ld ($x), 0x00"); 
			add_synth($cpu, "${pref}clr ($x+%d)", "${pref}ld ($x+%d), 0x00"); 
		}
	}
	
	for my $rp ('bc', 'de', 'hl') {
		for my $pref (@rabbit_prefixes) {
			for my $tick ("", "'") {
				add_synth($cpu, "${pref}clr $rp$tick", "${pref}ld $rp$tick, 0x0000");
			}
		}
	}

	for my $rp ('ix', 'iy') {
		add_synth($cpu, "clr $rp", "ld $rp, 0x0000");
	}
	
	# NEG
	add_synth($cpu, "neg", "cpl", "inc a");
	add_synth($cpu, "neg a", "cpl", "inc a");

	# DAA
	add_emul($cpu, "daa", "__z80asm__daa");

	# RRD / RLD
	add_emul($cpu, "rrd", "__z80asm__rrd");
	add_emul($cpu, "rld", "__z80asm__rld");
	
	#--------------------------------------------------------------------------
	# 16-bit ALU
	#--------------------------------------------------------------------------

	# ADC HL, rp
	for my $rp ('bc', 'de', 'hl', 'sp') {
		add_emul($cpu, "adc hl, $rp", "__z80asm__adc_hl_$rp");
	}
		
	# ADD BC|DE, %m
	for my $rp ('bc', 'de') {
		add_synth($cpu, "add $rp, %m", 
							"push hl", 
							"ld hl, %m", "add hl, $rp", "ld $rp, hl", 
							"pop hl");
	}
	
	# ADD HL, %m
	add_synth($cpu, "add hl, %m", 
						"push de", 
						"ld de, %m", "add hl, de",  
						"pop de");
	
	# ADD SP, n
	add_emul($cpu, "add sp, %s", "__z80asm__add_sp_s", '%s');

	# ADD rp, A
	for my $rp ('bc', 'de', 'hl') {
		add_emul($cpu, "add $rp, a", "__z80asm__add_${rp}_a");
	}
	
	# SBC HL, rp
	for my $rp ('bc', 'de', 'hl', 'sp') {
		add_emul($cpu, "sbc hl, $rp", "__z80asm__sbc_hl_$rp");
	}

	# SUB HL, rp
	add_emul($cpu, "dsub", "__z80asm__sub_hl_bc");
	for my $rp ('bc', 'de', 'hl', 'sp') {
		add_emul($cpu, "sub hl, $rp", "__z80asm__sub_hl_$rp");
	}

	# BOOL HL|IXY
	add_synth($cpu, "bool hl", 
						"push af", 
						"ld a, h", "or l", "jr z, %t1", "ld hl, 0x0001",
						"pop af");
	if (get_opcode($cpu, "ld ix, %m")) {
		for my $x ('ix', 'iy') {
			add_synth($cpu, "bool $x", 
								"push af", 
								"ld a, ${x}h", "or ${x}l", "jr z, %t1", "ld $x, 0x0001",
								"pop af");
			add_synth($cpu, "bool $x", 
								"push af", "push hl", 
								"ld hl, $x",
								"ld a, h", "or l", "jr z, %t2", "ld $x, 0x0001",
								"pop hl", "pop af");
		}
	}
		
	#--------------------------------------------------------------------------
	# 16-bit bit mask operations
	#--------------------------------------------------------------------------

	# AND|OR|XOR HL, rp
	for my $op ('and', 'or', 'xor') {
		for my $rp ('bc', 'de') {
			my($h, $l) = split //, $rp;
			add_synth($cpu, "$op hl, $rp",
								"push af",
								"ld a, h", "$op $h", "ld h, a",
								"ld a, l", "$op $l", "ld l, a",
								"pop af");
		}
	}

	# AND|OR|XOR IXY, rp
	for my $op ('and', 'or', 'xor') {
		for my $x ('ix', 'iy') {
			for my $rp ('bc', 'de') {
				my($h, $l) = split //, $rp;
				add_synth($cpu, "$op $x, $rp",
									"push af",
									"ld a, ${x}h", "$op $h", "ld ${x}h, a",
									"ld a, ${x}l", "$op $l", "ld ${x}l, a",
									"pop af");
			}
		}
	}

	#--------------------------------------------------------------------------
	# 16-bit shifts and rotates
	#--------------------------------------------------------------------------

	# SRA rp
	for my $rp ('bc', 'de', 'hl') {
		my($h, $l) = split //, $rp;
		add_synth($cpu, "sra $rp", "sra $h", "rr $l");
		add_emul($cpu, "sra $rp", "__z80asm__sra_$rp");
	}

	# SRA HL
	for my $asm ("arhl", "rrhl", "sra hl") {
		add_synth($cpu, $asm, "sra hl");
		add_synth($cpu, $asm, "sra h", "rr l");
		add_emul($cpu, $asm, "__z80asm__sra_hl");
	}
	
	# RL rp
	for my $rp ('bc', 'de', 'hl') {
		my($h, $l) = split //, $rp;
		add_synth($cpu, "rl $rp", "rl $l", "rl $h");
		add_emul($cpu, "rl $rp", "__z80asm__rl_$rp");
	}

	# RL DE
	for my $asm ("rdel", "rlde", "rl de") {
		add_synth($cpu, $asm, "rl de");
		add_synth($cpu, $asm, "rl e", "rl d");
		add_emul($cpu, $asm, "__z80asm__rl_de");
	}
	
	# RR rp
	for my $rp ('bc', 'de', 'hl') {
		my($h, $l) = split //, $rp;
		add_synth($cpu, "rr $rp", "rr $h", "rr $l");
		add_emul($cpu, "rr $rp", "__z80asm__rr_$rp");
	}

	#--------------------------------------------------------------------------
	# Block move and search group
	#--------------------------------------------------------------------------

	for my $asm ('ldi', 'ldir', 'ldd', 'lddr',
				 'cpi', 'cpir', 'cpd', 'cpdr') {
		add_emul($cpu, $asm, "__z80asm__$asm");
	}

	#--------------------------------------------------------------------------
	# Post increment/decrement
	#--------------------------------------------------------------------------

	# ALU
	for my $op ('add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp', 'cmp') {
		for my $a_ ("", "a, ", "a', ") {
			for my $pref (@rabbit_prefixes) {
				for my $suf (@ez80_suffixes) {
					add_synth($cpu, "$pref$op$suf $a_(hl+)", "$pref$op$suf $a_(hl)", "inc hl"); 
					add_synth($cpu, "$pref$op$suf $a_(hl-)", "$pref$op$suf $a_(hl)", "dec hl"); 
				}
			}
		}
	}
	
	# INC / DEC
	for my $op ('inc', 'dec') {
		for my $pref (@rabbit_prefixes) {
			for my $suf (@ez80_suffixes) {
				add_synth($cpu, "$pref$op$suf (hl+)", "$pref$op$suf (hl)", "inc hl"); 
				add_synth($cpu, "$pref$op$suf (hl-)", "$pref$op$suf (hl)", "dec hl"); 
			}
		}
	}
	
	# LD r, (rp) / LD (rp), r
	for my $rp ('bc', 'de', 'hl') {
		for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
			add_synth($cpu, "ld $r, ($rp+)", "ld $r, ($rp)", "inc $rp"); 
			add_synth($cpu, "ldi $r, ($rp)", "ld $r, ($rp)", "inc $rp"); 
			if ($rp eq 'hl') {
				add_synth($cpu, "ld $r, (hli)", "ld $r, (hl)", "inc hl"); 
			}

			add_synth($cpu, "ld $r, ($rp-)", "ld $r, ($rp)", "dec $rp"); 
			add_synth($cpu, "ldd $r, ($rp)", "ld $r, ($rp)", "dec $rp"); 
			if ($rp eq 'hl') {
				add_synth($cpu, "ld $r, (hld)", "ld $r, (hl)", "dec hl"); 
			}
			
			add_synth($cpu, "ld ($rp+), $r", "ld ($rp), $r", "inc $rp"); 
			add_synth($cpu, "ldi ($rp), $r", "ld ($rp), $r", "inc $rp"); 
			if ($rp eq 'hl') {
				add_synth($cpu, "ld (hli), $r", "ld (hl), $r", "inc hl"); 
			}

			add_synth($cpu, "ld ($rp-), $r", "ld ($rp), $r", "dec $rp"); 
			add_synth($cpu, "ldd ($rp), $r", "ld ($rp), $r", "dec $rp"); 
			if ($rp eq 'hl') {
				add_synth($cpu, "ld (hld), $r", "ld (hl), $r", "dec hl"); 
			}
		}
		
		add_synth($cpu, "ld ($rp+), %n", "ld ($rp), %n", "inc $rp"); 
		add_synth($cpu, "ldi ($rp), %n", "ld ($rp), %n", "inc $rp"); 

		add_synth($cpu, "ld ($rp-), %n", "ld ($rp), %n", "dec $rp"); 
		add_synth($cpu, "ldd ($rp), %n", "ld ($rp), %n", "dec $rp"); 
	}
	
	# LD r, (DE) / LD (DE), r
	if ($cpu !~ /^gbz80/) {		# gameboy lack ex de, hl
		for (['b','b'], ['c','c'], ['d','h'], ['e','l'], ['h','d'], ['l','e']) {
			my($r, $rswap) = @$_;
			
			add_synth($cpu, "ld (de), $r", "ex de, hl", "ld (hl), $rswap", "ex de, hl");
			add_synth($cpu, "ld (de+), $r", "ex de, hl", "ld (hl), $rswap", "ex de, hl", "inc de");
			add_synth($cpu, "ldi (de), $r", "ex de, hl", "ld (hl), $rswap", "ex de, hl", "inc de");
			add_synth($cpu, "ld (de-), $r", "ex de, hl", "ld (hl), $rswap", "ex de, hl", "dec de");
			add_synth($cpu, "ldd (de), $r", "ex de, hl", "ld (hl), $rswap", "ex de, hl", "dec de");
			
			add_synth($cpu, "ld $r, (de)", "ex de, hl", "ld $rswap, (hl)", "ex de, hl");
			add_synth($cpu, "ld $r, (de+)", "ex de, hl", "ld $rswap, (hl)", "ex de, hl", "inc de");
			add_synth($cpu, "ldi $r, (de)", "ex de, hl", "ld $rswap, (hl)", "ex de, hl", "inc de");
			add_synth($cpu, "ld $r, (de-)", "ex de, hl", "ld $rswap, (hl)", "ex de, hl", "dec de");
			add_synth($cpu, "ldd $r, (de)", "ex de, hl", "ld $rswap, (hl)", "ex de, hl", "dec de");
		}
	
		add_synth($cpu, "ld (de), %n", "ex de, hl", "ld (hl), %n", "ex de, hl");
		add_synth($cpu, "ld (de+), %n", "ex de, hl", "ld (hl), %n", "ex de, hl", "inc de");
		add_synth($cpu, "ldi (de), %n", "ex de, hl", "ld (hl), %n", "ex de, hl", "inc de");
		add_synth($cpu, "ld (de-), %n", "ex de, hl", "ld (hl), %n", "ex de, hl", "dec de");
		add_synth($cpu, "ldd (de), %n", "ex de, hl", "ld (hl), %n", "ex de, hl", "dec de");
	}
}

1;
