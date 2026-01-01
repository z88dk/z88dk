#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

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
	}

	# DJNZ
	if ($cpu =~ /^(8080|8085)/) {
		add_synth($cpu, "djnz %j", "dec b", "jp nz, %m");
		add_synth($cpu, "djnz b, %j", "dec b", "jp nz, %m");
	}
	elsif ($cpu =~ /^gbz80/) {
		add_synth($cpu, "djnz %j", "dec b", "jr nz, %j");
		add_synth($cpu, "djnz b, %j", "dec b", "jr nz, %j");
	}

	for (['jr','nc','c'], ['jr','nz','z'], ['jp','m','p'], ['jp','po','pe'], ['jp','lz','lo'], ['jp','nv','v']) {
		my($jump, $f, $nf) = @$_;

		# CALL <F>, NN
		add_synth($cpu, "call $f, %m", "$jump $nf, %t", "call %m");
		add_synth($cpu, "call $nf, %m", "$jump $f, %t", "call %m");
		
		# C<F> NN
		add_synth($cpu, "c$f %m", "$jump $nf, %t", "call %m") if $f ne 'p';
		add_synth($cpu, "c$nf %m", "$jump $f, %t", "call %m") if $nf ne 'p';

		# C<F> NN
		add_synth($cpu, "c_$f %m", "$jump $nf, %t", "call %m");
		add_synth($cpu, "c_$nf %m", "$jump $f, %t", "call %m");

		# RET3 <F>
		add_synth($cpu, "ret3 $f", "$jump $nf, %t", "ret3");
		add_synth($cpu, "ret3 $nf", "$jump $f, %t", "ret3");
	}

	for (['gt','le'], ['gtu','leu'], ['lt','ge'], ['v','nv']) {
		my($f, $nf) = @$_;

		# JP <NF>, NN
		add_synth($cpu, "jp $nf, %m", "jp $f, %t", "jp %m");
		add_synth($cpu, "j$nf %m", "jp $f, %t", "jp %m");
		add_synth($cpu, "j_$nf %m", "jp $f, %t", "jp %m");
	}

	# JP|CALL|RET EQ, NN
	add_synth($cpu, "jeq %m", "jz %m");
	add_synth($cpu, "j_eq %m", "jz %m");
	add_synth($cpu, "jr eq, %j", "jr z, %j");
	add_synth($cpu, "jre eq, %J", "jre z, %J");
	add_synth($cpu, "jp3 eq, %m", "jp3 z, %m");
	add_synth($cpu, "ceq %m", "cz %m");
	add_synth($cpu, "call3 eq, %m", "call3 z, %m");
	add_synth($cpu, "c_eq %m", "cz %m");
	for my $suf (@ez80_suffixes) {
		add_synth($cpu, "jp$suf eq, %m", "jp$suf z, %m");
		add_synth($cpu, "jmp$suf eq, %m", "jp$suf z, %m");
		add_synth($cpu, "call$suf eq, %m", "call$suf z, %m");
		add_synth($cpu, "ret$suf eq", "ret$suf z");
	}
	add_synth($cpu, "req", "rz");
	add_synth($cpu, "ret3 eq", "jr nz, %t", "ret3");
	add_synth($cpu, "r_eq", "rz");

	# JP|CALL|RET NE, NN
	add_synth($cpu, "jne %m", "jnz %m");
	add_synth($cpu, "j_ne %m", "jnz %m");
	add_synth($cpu, "jr ne, %j", "jr nz, %j");
	add_synth($cpu, "jre ne, %J", "jre nz, %J");
	add_synth($cpu, "jp3 ne, %m", "jp3 nz, %m");
	add_synth($cpu, "cne %m", "cnz %m");
	add_synth($cpu, "call3 ne, %m", "call3 nz, %m");
	add_synth($cpu, "c_ne %m", "cnz %m");
	for my $suf (@ez80_suffixes) {
		add_synth($cpu, "jp$suf ne, %m", "jp$suf nz, %m");
		add_synth($cpu, "jmp$suf ne, %m", "jp$suf nz, %m");
		add_synth($cpu, "call$suf ne, %m", "call$suf nz, %m");
		add_synth($cpu, "ret$suf ne", "ret$suf nz");
	}
	add_synth($cpu, "rne", "rnz");
	add_synth($cpu, "ret3 ne", "jr z, %t", "ret3");
	add_synth($cpu, "r_ne", "rnz");

	# JP|CALL|RET GEU, NN
	add_synth($cpu, "jgeu %m", "jnc %m");
	add_synth($cpu, "j_geu %m", "jnc %m");
	add_synth($cpu, "jr geu, %j", "jr nc, %j");
	add_synth($cpu, "jre geu, %J", "jre nc, %J");
	add_synth($cpu, "jp3 geu, %m", "jp3 nc, %m");
	add_synth($cpu, "cgeu %m", "cnc %m");
	add_synth($cpu, "call3 geu, %m", "call3 nc, %m");
	add_synth($cpu, "c_geu %m", "cnc %m");
	for my $suf (@ez80_suffixes) {
		add_synth($cpu, "jp$suf geu, %m", "jp$suf nc, %m");
		add_synth($cpu, "jmp$suf geu, %m", "jp$suf nc, %m");
		add_synth($cpu, "call$suf geu, %m", "call$suf nc, %m");
		add_synth($cpu, "ret$suf geu", "ret$suf nc");
	}
	add_synth($cpu, "rgeu", "rnc");
	add_synth($cpu, "ret3 geu", "jr c, %t", "ret3");
	add_synth($cpu, "r_geu", "rnc");

	# JP|CALL|RET LTU, NN
	add_synth($cpu, "jltu %m", "jc %m");
	add_synth($cpu, "j_ltu %m", "jc %m");
	add_synth($cpu, "jr ltu, %j", "jr c, %j");
	add_synth($cpu, "jre ltu, %J", "jre c, %J");
	add_synth($cpu, "jp3 ltu, %m", "jp3 c, %m");
	add_synth($cpu, "cltu %m", "cc %m");
	add_synth($cpu, "call3 ltu, %m", "call3 c, %m");
	add_synth($cpu, "c_ltu %m", "cc %m");
	for my $suf (@ez80_suffixes) {
		add_synth($cpu, "jp$suf ltu, %m", "jp$suf c, %m");
		add_synth($cpu, "jmp$suf ltu, %m", "jp$suf c, %m");
		add_synth($cpu, "call$suf ltu, %m", "call$suf c, %m");
		add_synth($cpu, "ret$suf ltu", "ret$suf c");
	}
	add_synth($cpu, "rltu", "rc");
	add_synth($cpu, "ret3 ltu", "jr nc, %t", "ret3");
	add_synth($cpu, "r_ltu", "rc");
	
	# JP|CALL|RET GTU, NN
	add_synth($cpu, "jgtu %m", "jr z, %t", "jp nc, %m");
	add_synth($cpu, "jgtu %m", "jz %t", "jnc %m");

	add_synth($cpu, "j_gtu %m", "jr z, %t", "jp nc, %m");
	add_synth($cpu, "j_gtu %m", "jz %t", "jnc %m");

    add_synth($cpu, "jr gtu, %j", "jr z, %t", "jr nc, %j");
	add_synth($cpu, "jre gtu, %J", "jr z, %t", "jre nc, %J");
	add_synth($cpu, "jp3 gtu, %m", "jr z, %t", "jp3 nc, %m");
	add_synth($cpu, "cgtu %m", "jr z, %t", "call nc, %m");
	add_synth($cpu, "call3 gtu, %m", "jr z, %t", "call3 nc, %m");
	add_synth($cpu, "c_gtu %m", "jr z, %t", "call nc, %m");
	for my $suf (@ez80_suffixes) {
		add_synth($cpu, "jp$suf gtu, %m", "jr z, %t", "jp$suf nc, %m");
		add_synth($cpu, "jmp$suf gtu, %m", "jr z, %t", "jp$suf nc, %m");
		add_synth($cpu, "call$suf gtu, %m", "jr z, %t", "call$suf nc, %m");
		add_synth($cpu, "ret$suf gtu", "jr z, %t", "ret$suf nc");
	}
	add_synth($cpu, "rgtu", "jr z, %t", "rnc");
	add_synth($cpu, "ret3 gtu", "jr z, %t", "jr c, %t", "ret3");
	add_synth($cpu, "r_gtu", "jr z, %t", "rnc");

	# JP|CALL|RET LEU, NN
	add_synth($cpu, "jleu %m", "jz %m", "jc %m");
	add_synth($cpu, "j_leu %m", "jz %m", "jc %m");
	add_synth($cpu, "jr leu, %j", "jr z, %j", "jr c, %j");
	add_synth($cpu, "jre leu, %J", "jr z, %t3", "jr c, %t3", "jr %t", "jre %J");
	add_synth($cpu, "jp3 leu, %m", "jp3 z, %m", "jp3 c, %m");
	for my $suf (@ez80_suffixes) {
		# ez80 size of call instuction
		my $call_size = 3;
		my $call_opcode = get_opcode($cpu, "call$suf %m");
		if ($call_opcode) {
			$call_size = scalar($call_opcode->bytes);
		}
	
		add_synth($cpu, "cleu %m", "jr z, %t$call_size", "jr nc, %t", "call %m");
		add_synth($cpu, "call3 leu, %m", "jr z, %t$call_size", "jr nc, %t", "call3 %m");
		add_synth($cpu, "c_leu %m", "jr z, %t$call_size", "jr nc, %t", "call %m");

		add_synth($cpu, "jp$suf leu, %m", "jp$suf z, %m", "jp$suf c, %m");
		add_synth($cpu, "jmp$suf leu, %m", "jp$suf z, %m", "jp$suf c, %m");
		add_synth($cpu, "call$suf leu, %m", "jr z, %t$call_size", "jr nc, %t", "call$suf %m");
		add_synth($cpu, "ret$suf leu", "ret$suf z", "ret$suf c");
	}
	add_synth($cpu, "rleu", "rz", "rc");
	add_synth($cpu, "ret3 leu", "jr nz, %t", "jr nc, %t", "ret3");
	add_synth($cpu, "r_leu", "rz", "rc");

	# JP|CALL|RET NV, NN
	if ($cpu =~ /^(r4k|r5k|r6k)/) {		# jp v exists
		add_synth($cpu, "jnv %m", "jp v, %t", "jp %m");
		add_synth($cpu, "j_nv %m", "jp v, %t", "jp %m");
		add_synth($cpu, "jp nv, %m", "jp v, %t", "jp %m");
		add_synth($cpu, "jre nv, %J", "jp v, %t", "jre %J");
		add_synth($cpu, "jmp nv, %m", "jp v, %t", "jp %m");
		add_synth($cpu, "cnv %m", "jp v, %t", "call %m");
		add_synth($cpu, "c_nv %m", "jp v, %t", "call %m");
		add_synth($cpu, "call nv, %m", "jp v, %t", "call %m");
		add_synth($cpu, "ret nv", "jp v, %t", "ret");
		add_synth($cpu, "rnv", "jp v, %t", "ret");
		add_synth($cpu, "r_nv", "jp v, %t", "ret");
	}
	else {
		add_synth($cpu, "jnv %m", "jpo %m");
		add_synth($cpu, "j_nv %m", "jpo %m");
		add_synth($cpu, "jp3 nv, %m", "jp3 po, %m");
		add_synth($cpu, "cnv %m", "cpo %m");
		add_synth($cpu, "call3 nv, %m", "call3 po, %m");
		add_synth($cpu, "c_nv %m", "cpo %m");
		for my $suf (@ez80_suffixes) {
			add_synth($cpu, "jp$suf nv, %m", "jp$suf po, %m");
			add_synth($cpu, "jmp$suf nv, %m", "jp$suf po, %m");
			add_synth($cpu, "call$suf nv, %m", "call$suf po, %m");
			add_synth($cpu, "ret$suf nv", "ret$suf po");
		}
		add_synth($cpu, "rnv", "rpo");
		add_synth($cpu, "ret3 nv", "jp pe, %t", "ret3");
		add_synth($cpu, "r_nv", "rpo");
	}

	# JP|CALL|RET V, NN
	if ($cpu =~ /^(r4k|r5k|r6k)/) {		# jp v exists
		add_synth($cpu, "jv %m", "jp v, %m");
		add_synth($cpu, "j_v %m", "jp v, %m");
		add_synth($cpu, "jre v, %J", "jre v, %J");
		add_synth($cpu, "jmp v, %m", "jp v, %m");
		add_synth($cpu, "cv %m", "jp v, %t3", "jr %t", "call %m");
		add_synth($cpu, "c_v %m", "jp v, %t3", "jr %t", "call %m");
		add_synth($cpu, "call v, %m", "jp v, %t3", "jr %t", "call %m");
		add_synth($cpu, "ret v", "jp v, %t1", "jr %t", "ret");
		add_synth($cpu, "rv", "jp v, %t1", "jr %t", "ret");
		add_synth($cpu, "r_v", "jp v, %t1", "jr %t", "ret");
	}
	else {
		add_synth($cpu, "jv %m", "jpe %m");
		add_synth($cpu, "j_v %m", "jpe %m");
		add_synth($cpu, "jp3 v, %m", "jp3 pe, %m");
		add_synth($cpu, "cv %m", "cpe %m");
		add_synth($cpu, "call3 v, %m", "call3 pe, %m");
		add_synth($cpu, "c_v %m", "cpe %m");
		for my $suf (@ez80_suffixes) {
			add_synth($cpu, "jp$suf v, %m", "jp$suf pe, %m");
			add_synth($cpu, "jmp$suf v, %m", "jp$suf pe, %m");
			add_synth($cpu, "call$suf v, %m", "call$suf pe, %m");
			add_synth($cpu, "ret$suf v", "ret$suf pe");
		}
		add_synth($cpu, "rv", "rpe");
		add_synth($cpu, "ret3 v", "jp po, %t", "ret3");
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

	add_synth($cpu, "ex bc, hl", "push hl : push bc : pop hl : pop bc");
	add_synth($cpu, "ex hl, bc", "ex bc, hl");

	add_synth($cpu, "ex de, hl", "push hl : push de : pop hl : pop de");
	add_synth($cpu, "ex hl, de", "ex de, hl");
	add_synth($cpu, "xchg", "ex de, hl");

    for my $asm ("ex af', af", "ex af, af") {
        add_synth($cpu, $asm, "ex af, af'");
    }
    
	for my $asm ("ex bc, hl", "ex hl, bc") {
		add_synth($cpu, $asm, "push hl : push bc : pop hl : pop bc");
	}
	
	add_emul($cpu, "ex (sp), hl", "__z80asm__ex_sp_hl");
	
	add_synth($cpu, "xthl", "ex (sp), hl");

	add_synth($cpu, "ex bcde, jkhl", "ex jkhl, bcde");
	add_synth($cpu, "ex hl, bc", "ex bc, hl");
	add_synth($cpu, "ex hl', bc", "ex bc, hl'");
	add_synth($cpu, "ex hl, bc'", "ex bc', hl");
	add_synth($cpu, "ex hl', bc'", "ex bc', hl'");
	add_synth($cpu, "ex hl', de", "ex de, hl'");
	add_synth($cpu, "ex hl, de'", "ex de', hl");
	add_synth($cpu, "ex hl', de'", "ex de', hl'");
	add_synth($cpu, "ex hl, jk", "ex jk, hl");
	add_synth($cpu, "ex hl', jk", "ex jk, hl'");
	add_synth($cpu, "ex hl, jk'", "ex jk', hl");
	add_synth($cpu, "ex hl', jk'", "ex jk', hl'");
	
	#--------------------------------------------------------------------------
	# 16-bit load
	#--------------------------------------------------------------------------

	# LD rp1, rp2
	for my $pref (@rabbit_prefixes) {
		for my $rp1 ('bc', 'de', 'hl') {
			my($h1, $l1) = split //, $rp1;
			for my $rp2 ('bc', 'de', 'hl') {
				next if $rp1 eq $rp2;
				my($h2, $l2) = split //, $rp2;
				add_synth($cpu, "${pref}ld $rp1, $rp2", "${pref}ld $h1, $h2", "${pref}ld $l1, $l2");
			}
		}
	}

	# rabbit load alternate
	for my $rp1 ('bc', 'de', 'hl') {
		my($h1, $l1) = split //, $rp1;
		for my $rp2 ('bc', 'de', 'hl') {
			my($h2, $l2) = split //, $rp2;
			add_synth($cpu, "ld $rp1', $rp2", "ld $h1', $h2", "ld $l1', $l2");
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

	# rabbit push alternate
	for my $rp ('bc', 'de', 'hl') {
		add_synth($cpu, "push $rp'", "exx : push $rp : exx");
	}

	# rabbit load alternate
	for my $rp1 ('bc', 'de', 'hl') {
		for my $rp2 ('bc', 'de', 'hl') {
			next if $rp1 eq $rp2;
			add_synth($cpu, "ld $rp1', $rp2'", "exx : ld $rp1, $rp2 : exx");
		}
	}

	# all the others via push-pop
	for my $rp1 ("bc", "de", "hl", "bc'", "de'", "hl'", "ix", "iy") {
		for my $rp2 ("bc", "de", "hl", "bc'", "de'", "hl'", "ix", "iy") {
			next if $rp1 eq $rp2;
			add_synth($cpu, "ld $rp1, $rp2", "push $rp2", "pop $rp1");
		}
	}

	#--------------------------------------------------------------------------
	# 16-bit load plus 8-bit offset
	#--------------------------------------------------------------------------

	# LD DE, HL+n
	for my $asm ("ldhi %n", "adi hl, %n", "ld de, hl+%n") {
		my($var) = $asm =~ /(%\w)/;
		add_synth($cpu, $asm, 
							"push hl", 
							"ld de, 0:$var", "add hl, de", "ex de, hl", 
							"pop hl");
	}

	# LD DE, SP+n
	for my $asm ("ldsi %n", "adi sp, %n", "ld de, sp+%n") {
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
	
	# LD HL, SP+d
    if ($cpu =~ /^8085/) {
        add_synth($cpu, "ld hl, sp+%n", 
							"ex de, hl", 
							"ld de, sp+%n", 
							"ex de, hl");
        add_synth($cpu, "ld hl, sp", 
							"ex de, hl", 
							"ld de, sp", 
							"ex de, hl");
    }
    else {
        add_synth($cpu, "ld hl, sp+%d", 
                            "ld hl, 0:%d", "add hl, sp");
        add_synth($cpu, "ld hl, sp", 
                            "ld hl, 0x0000", "add hl, sp");
    }
	
	#--------------------------------------------------------------------------
	# 16-bit memory load
	#--------------------------------------------------------------------------

	add_synth($cpu, "ld bc, (%m)", 
						"push hl", 
						"ld hl, (%m) : ld bc, hl", 
						"pop hl");
	add_synth($cpu, "ld bc, (%m)", 
						"push af",
						"ld a, (%m) : ld c, a : ld a, (%m1) : ld b, a",
						"pop af");
						
	add_synth($cpu, "ld (%m), bc", 
						"push hl", 
						"ld hl, bc : ld (%m), hl", 
						"pop hl");
	add_synth($cpu, "ld (%m), bc", 
						"push af", 
						"ld a, c : ld (%m), a : ld a, b : ld (%m1), a", 
						"pop af");
	
	add_synth($cpu, "ld de, (%m)", 
						"ex de, hl", "ld hl, (%m)", "ex de, hl");
	add_synth($cpu, "ld de, (%m)", 
						"push af",
						"ld a, (%m) : ld e, a : ld a, (%m1) : ld d, a",
						"pop af");
						
	add_synth($cpu, "ld (%m), de", 
						"ex de, hl", "ld (%m), hl", "ex de, hl");
	add_synth($cpu, "ld (%m), de", 
						"push af", 
						"ld a, e : ld (%m), a : ld a, d : ld (%m1), a", 
						"pop af");
	
	# LD HL, (NN) / LD (NN), HL
	add_synth($cpu, "ld hl, (%m)", 
						"push af",
						"ld a, (%m) : ld l, a : ld a, (%m1) : ld h, a",
						"pop af");
						
	add_synth($cpu, "ld (%m), hl", 
						"push af", 
						"ld a, l : ld (%m), a : ld a, h : ld (%m1), a", 
						"pop af");

	add_synth($cpu, "lhld %m", "ld hl, (%m)");
	add_synth($cpu, "shld %m", "ld (%m), hl");
	
	# LD (NN), SP - account for the pushed hl on the stack
	add_synth($cpu, "ld (%m), sp", 
						"push hl",
						"ld hl, 0x0002", "add hl, sp", "ld (%m), hl",
						"pop hl");
	
	#--------------------------------------------------------------------------
	# 16-bit indirect load
	#--------------------------------------------------------------------------

	# LD (HL), BC|DE
	for my $suf (@ez80_suffixes) {
		for my $rp ('bc', 'de') {
			my($h, $l) = split //, $rp;
			if ($cpu =~ /ez80/) {
				add_synth($cpu, "ld$suf (hl+), $rp", 
									"ld$suf (hl), $rp", "inc$suf hl", "inc$suf hl");
				add_synth($cpu, "ldi$suf (hl), $rp", 
									"ld$suf (hl), $rp", "inc$suf hl", "inc$suf hl");
			}
			else {
				add_synth($cpu, "ld$suf (hl), $rp", 
									"ld$suf (hl), $l", "inc$suf hl", "ld$suf (hl), $h", "dec$suf hl");
				add_synth($cpu, "ld$suf (hl+), $rp", 
									"ld$suf (hl), $l", "inc$suf hl", "ld$suf (hl), $h", "inc$suf hl");
				add_synth($cpu, "ldi$suf (hl), $rp", 
									"ld$suf (hl), $l", "inc$suf hl", "ld$suf (hl), $h", "inc$suf hl");
			}
		}
	}

	# LD (HL), HL
	if ($cpu !~ /^r\dk/) {	# not yet for Rabbits
		if ($cpu =~ /ez80/) {
			for my $suf (@ez80_suffixes) {
				add_synth($cpu, "ld$suf (hl+), hl",
									"ld$suf (hl), hl", "inc$suf hl", "inc$suf hl");
				add_synth($cpu, "ldi$suf (hl), hl",
									"ld$suf (hl), hl", "inc$suf hl", "inc$suf hl");
			}
		}
		else {
			add_synth($cpu, "ld (hl), hl",
								"push af", 
								"ld a, h", "ld (hl), l", "inc hl", "ld (hl), a",
								"pop af", "dec hl");
			add_synth($cpu, "ld (hl+), hl",
								"push af", 
								"ld a, h", "ld (hl), l", "inc hl", "ld (hl), a",
								"pop af", "inc hl");
			add_synth($cpu, "ldi (hl), hl",
								"push af", 
								"ld a, h", "ld (hl), l", "inc hl", "ld (hl), a",
								"pop af", "inc hl");
		}
	}

	# LD (HL), IX|IY
	for my $x ('ix', 'iy') {
		add_synth($cpu, "ld (hl), $x", 
							"push de",
							"push $x", "pop de",
							"ld (hl), e", "inc hl", "ld (hl), d", "dec hl",
							"pop de");
		if ($cpu =~ /ez80/) {
			for my $suf (@ez80_suffixes) {
				add_synth($cpu, "ld$suf (hl+), $x", 
									"ld$suf (hl), $x : inc$suf hl : inc$suf hl");
				add_synth($cpu, "ldi$suf (hl), $x", 
									"ld$suf (hl), $x : inc$suf hl : inc$suf hl");
			}
		}
		else {
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
	}

	# LD (IX+d), BC|DE|HL|IX|IY
	for my $x ('ix', 'iy') {
		add_synth($cpu, "ld ($x+%d), bc", "ld ($x+%d), c", "ld ($x+%d1), b");
		add_synth($cpu, "ld ($x), bc", "ld ($x), c", "ld ($x+0x01), b");

		add_synth($cpu, "ld ($x+%d), de", "ld ($x+%d), e", "ld ($x+%d1), d");
		add_synth($cpu, "ld ($x), de", "ld ($x), e", "ld ($x+0x01), d");

		if ($cpu !~ /^r\dk/) {	# not yet for Rabbits
			add_synth($cpu, "ld ($x+%d), hl", "ld ($x+%d), l", "ld ($x+%d1), h");
			add_synth($cpu, "ld ($x), hl", "ld ($x), l", "ld ($x+0x01), h");
		}

		for my $x1 ('ix', 'iy') {
			add_synth($cpu, "ld ($x+%d), $x1",
					  "push $x1", "ex (sp), hl",
					  "ld ($x+%d), l", "ld ($x+%d1), h",
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
		if ($cpu =~ /ez80/) {
			for my $suf (@ez80_suffixes) {
				add_synth($cpu, "ld$suf $x, (hl+)",
							"ld$suf $x, (hl) : inc$suf hl : inc$suf hl");
				add_synth($cpu, "ldi$suf $x, (hl)",
							"ld$suf $x, (hl) : inc$suf hl : inc$suf hl");
			}
		}
		else {
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
	}

	# LD BC|DE, (HL)
	for my $rp ('bc', 'de') {
		my($h, $l) = split //, $rp;
		if ($cpu =~ /ez80/) {
			for my $suf (@ez80_suffixes) {
				add_synth($cpu, "ld$suf $rp, (hl+)", 
									"ld$suf $rp, (hl)", "inc$suf hl", "inc$suf hl");
				add_synth($cpu, "ldi$suf $rp, (hl)", 
									"ld$suf $rp, (hl)", "inc$suf hl", "inc$suf hl");
			}
		}
		else {
			add_synth($cpu, "ld $rp, (hl)", 
								"ld $l, (hl)", "inc hl", "ld $h, (hl)", "dec hl");
			add_synth($cpu, "ld $rp, (hl+)", 
								"ld $l, (hl)", "inc hl", "ld $h, (hl)", "inc hl");
			add_synth($cpu, "ldi $rp, (hl)", 
								"ld $l, (hl)", "inc hl", "ld $h, (hl)", "inc hl");
		}
	}
	
	# LD HL, (DE)
	add_synth($cpu, "ld hl, (de)", 
						"ex de, hl",
						"ld e, (hl)", "inc hl", "ld d, (hl)", "dec hl",
						"ex de, hl");
	add_synth($cpu, "lhlx", "ld hl, (de)");
	add_synth($cpu, "lhlde", "ld hl, (de)");
	
	# LD BC|DE|HL|IX, (IX+d)
	for my $x ('ix', 'iy') {
		add_synth($cpu, "ld bc, ($x+%d)", "ld c, ($x+%d)", "ld b, ($x+%d1)");
		add_synth($cpu, "ld bc, ($x)", "ld c, ($x)", "ld b, ($x+0x01)");

		add_synth($cpu, "ld de, ($x+%d)", "ld e, ($x+%d)", "ld d, ($x+%d1)");
		add_synth($cpu, "ld de, ($x)", "ld e, ($x)", "ld d, ($x+0x01)");

		add_synth($cpu, "ld hl, ($x+%d)", "ld l, ($x+%d)", "ld h, ($x+%d1)");
		add_synth($cpu, "ld hl, ($x)", "ld l, ($x)", "ld h, ($x+0x01)");

		for my $x1 ('ix', 'iy') {
			add_synth($cpu, "ld $x1, ($x+%d)",
					  "push $x1", "ex (sp), hl",
					  "ld l, ($x+%d)", "ld h, ($x+%d1)",
					  "ex (sp), hl", "pop $x1");
			add_synth($cpu, "ld $x1, ($x)",
					  "push $x1", "ex (sp), hl",
					  "ld l, ($x)", "ld h, ($x+0x01)",
					  "ex (sp), hl", "pop $x1");
		}
	}

	# LD (DE), HL
	add_synth($cpu, "ld (de), hl", 
						"ex de, hl",
						"ld (hl), e", "inc hl", "ld (hl), d", "dec hl",
						"ex de, hl");
	add_synth($cpu, "shlx", "ld (de), hl");
	add_synth($cpu, "shlde", "ld (de), hl");
	
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
	add_synth($cpu, "neg", "cpl : inc a");
	add_synth($cpu, "neg a", "cpl : inc a");

	for my $r ('b', 'c', 'd', 'e', 'h', 'l') {
		for my $tick ("", "'") {
			add_synth($cpu, "neg $r$tick", 
							"push af",
							"ld a, $r$tick : cpl : ld $r$tick, a : inc $r$tick",
							"pop af");
		}
	}

	for my $rp ('bc', 'de', 'hl') {
		for my $tick ("", "'") {
			my($h, $l) = split //, $rp;
			add_synth($cpu, "neg $rp$tick", 
						"push af",
						"ld a, $h$tick : cpl : ld $h$tick, a : ld a, $l$tick : cpl : ld $l$tick, a : inc $rp$tick",
						"pop af");
		}
	}

	for my $x ('ix', 'iy') {
		add_synth($cpu, "neg $x", 
					"push af",
					"ld a, ${x}h : cpl : ld ${x}h, a : ld a, ${x}l : cpl : ld ${x}l, a : inc $x",
					"pop af");
		add_synth($cpu, "neg $x", 
					"push hl : push $x : pop hl",
					"ld a, h : cpl : ld h, a : ld a, l : cpl : ld l, a : inc hl",
					"push hl : pop $x : pop hl");
	}

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
	add_emul($cpu, "add sp, %d", "__z80asm__add_sp_d", '%d');

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
					add_synth($cpu, "$pref$op$suf $a_(hl+)", "$pref$op$suf $a_(hl)", "inc$suf hl"); 
					add_synth($cpu, "$pref$op$suf $a_(hl-)", "$pref$op$suf $a_(hl)", "dec$suf hl"); 
				}
			}
		}
	}
	
	# INC / DEC
	for my $op ('inc', 'dec') {
		for my $pref (@rabbit_prefixes) {
			for my $suf (@ez80_suffixes) {
				add_synth($cpu, "$pref$op$suf (hl+)", "$pref$op$suf (hl)", "inc$suf hl"); 
				add_synth($cpu, "$pref$op$suf (hl-)", "$pref$op$suf (hl)", "dec$suf hl"); 
			}
		}
	}
	
	# LD r, (rp) / LD (rp), r
	for my $pref (@rabbit_prefixes) {
		for my $suf (@ez80_suffixes) {
			for my $rp ('bc', 'de', 'hl') {
				for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
					for my $tick ("", "'") {
						add_synth($cpu, "${pref}ld$suf $r$tick, ($rp+)", "${pref}ld$suf $r$tick, ($rp)", "inc$suf $rp"); 
						add_synth($cpu, "${pref}ldi$suf $r$tick, ($rp)", "${pref}ld$suf $r$tick, ($rp)", "inc$suf $rp"); 
						if ($rp eq 'hl') {
							add_synth($cpu, "${pref}ld$suf $r$tick, (hli)", "${pref}ld$suf $r$tick, (hl)", "inc$suf hl"); 
						}

						add_synth($cpu, "${pref}ld$suf $r$tick, ($rp-)", "${pref}ld$suf $r$tick, ($rp)", "dec$suf $rp"); 
						add_synth($cpu, "${pref}ldd$suf $r$tick, ($rp)", "${pref}ld$suf $r$tick, ($rp)", "dec$suf $rp"); 
						if ($rp eq 'hl') {
							add_synth($cpu, "${pref}ld$suf $r$tick, (hld)", "${pref}ld$suf $r$tick, (hl)", "dec$suf hl"); 
						}
						
						add_synth($cpu, "${pref}ld$suf ($rp+), $r$tick", "${pref}ld$suf ($rp), $r$tick", "inc$suf $rp"); 
						add_synth($cpu, "${pref}ldi$suf ($rp), $r$tick", "${pref}ld$suf ($rp), $r$tick", "inc$suf $rp"); 
						if ($rp eq 'hl') {
							add_synth($cpu, "${pref}ld$suf (hli), $r$tick", "${pref}ld$suf (hl), $r$tick", "inc$suf hl"); 
						}

						add_synth($cpu, "${pref}ld$suf ($rp-), $r$tick", "${pref}ld$suf ($rp), $r$tick", "dec$suf $rp"); 
						add_synth($cpu, "${pref}ldd$suf ($rp), $r$tick", "${pref}ld$suf ($rp), $r$tick", "dec$suf $rp"); 
						if ($rp eq 'hl') {
							add_synth($cpu, "${pref}ld$suf (hld), $r$tick", "${pref}ld$suf (hl), $r$tick", "dec$suf hl"); 
						}
					}
				}
			
				add_synth($cpu, "${pref}ld$suf ($rp+), %n", "${pref}ld$suf ($rp), %n", "inc$suf $rp"); 
				add_synth($cpu, "${pref}ldi$suf ($rp), %n", "${pref}ld$suf ($rp), %n", "inc$suf $rp"); 

				add_synth($cpu, "${pref}ld$suf ($rp-), %n", "${pref}ld$suf ($rp), %n", "dec$suf $rp"); 
				add_synth($cpu, "${pref}ldd$suf ($rp), %n", "${pref}ld$suf ($rp), %n", "dec$suf $rp"); 
			}
		}
	}

	# LD r, (DE) / LD (DE), r
	for my $suf (@ez80_suffixes) {
		if ($cpu !~ /^gbz80/) {		# gameboy lack ex de, hl
			for (['b','b'], ['c','c'], ['d','h'], ['e','l'], ['h','d'], ['l','e']) {
				my($r, $rswap) = @$_;
				
				add_synth($cpu, "ld$suf (de), $r", "ex de, hl", "ld$suf (hl), $rswap", "ex de, hl");
				add_synth($cpu, "ld$suf (de+), $r", "ex de, hl", "ld$suf (hl), $rswap", "ex de, hl", "inc$suf de");
				add_synth($cpu, "ldi$suf (de), $r", "ex de, hl", "ld$suf (hl), $rswap", "ex de, hl", "inc$suf de");
				add_synth($cpu, "ld$suf (de-), $r", "ex de, hl", "ld$suf (hl), $rswap", "ex de, hl", "dec$suf de");
				add_synth($cpu, "ldd$suf (de), $r", "ex de, hl", "ld$suf (hl), $rswap", "ex de, hl", "dec$suf de");
				
				add_synth($cpu, "ld$suf $r, (de)", "ex de, hl", "ld$suf $rswap, (hl)", "ex de, hl");
				add_synth($cpu, "ld$suf $r, (de+)", "ex de, hl", "ld$suf $rswap, (hl)", "ex de, hl", "inc$suf de");
				add_synth($cpu, "ldi$suf $r, (de)", "ex de, hl", "ld$suf $rswap, (hl)", "ex de, hl", "inc$suf de");
				add_synth($cpu, "ld$suf $r, (de-)", "ex de, hl", "ld$suf $rswap, (hl)", "ex de, hl", "dec$suf de");
				add_synth($cpu, "ldd$suf $r, (de)", "ex de, hl", "ld$suf $rswap, (hl)", "ex de, hl", "dec$suf de");
			}
		
			add_synth($cpu, "ld$suf (de), %n", "ex de, hl", "ld$suf (hl), %n", "ex de, hl");
			add_synth($cpu, "ld$suf (de+), %n", "ex de, hl", "ld$suf (hl), %n", "ex de, hl", "inc$suf de");
			add_synth($cpu, "ldi$suf (de), %n", "ex de, hl", "ld$suf (hl), %n", "ex de, hl", "inc$suf de");
			add_synth($cpu, "ld$suf (de-), %n", "ex de, hl", "ld$suf (hl), %n", "ex de, hl", "dec$suf de");
			add_synth($cpu, "ldd$suf (de), %n", "ex de, hl", "ld$suf (hl), %n", "ex de, hl", "dec$suf de");
		}
	}
}

1;
