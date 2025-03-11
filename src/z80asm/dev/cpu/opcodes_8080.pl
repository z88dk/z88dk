#------------------------------------------------------------------------------
# 8080
#------------------------------------------------------------------------------

for my $cpu1 ('8080') {
	for my $strict ('', '_strict') {
		my $cpu = $cpu1.$strict;

		add_mov_r_r($cpu);
        add_mvi_r_N($cpu);
		add_ld_r_r($cpu) if !$strict;
        add_ld_r_N($cpu) if !$strict;
        
		add_lxi_r_NN($cpu);
        add_lxi_rp_NN($cpu) if !$strict;
        add_ld_rp_NN($cpu) if !$strict;

        add_lda_sta($cpu);
        add_ld_a_iNN($cpu) if !$strict;

        add_lhld_shld($cpu);
        add_ld_hl_iNN($cpu) if !$strict;

        add_ldax_stax_r($cpu);
        add_ldax_stax_rp($cpu) if !$strict;
        add_ld_a_ibc($cpu) if !$strict;

        add_xchg($cpu);
        add_ex_de_hl($cpu) if !$strict;
        
        add_pchl($cpu);
        add_jp_hl($cpu) if !$strict;

        add_push_pop_r($cpu);
        add_push_pop_rp($cpu) if !$strict;

if(0){
		# INC/DEC r
		add_inc_dec_r_8080($opcodes, $cpu);
		add_inc_dec_r_z80($opcodes, $cpu) if !$strict;

		# INC/DEC rp
		add_inc_dec_rp1_8080($opcodes, $cpu);
		add_inc_dec_rp2_8080($opcodes, $cpu) if !$strict;
		add_inc_dec_rp_z80($opcodes, $cpu) if !$strict;

		# STAX rp
		for my $rp ('b', 'd') {
			$opcodes->add(Opcode->new(asm=>"stax $rp", cpu=>$cpu, 
									  ops=>[[0x02+16*RP($rp)]]));
		}
		if (!$strict) {
			for my $rp ('bc', 'de') {
				$opcodes->add(Opcode->new(asm=>"stax $rp", cpu=>$cpu, 
										  ops=>[[0x02+16*RP($rp)]]));
			}
		}

		# LD (rp), A
		if (!$strict) {
			for my $rp ('bc', 'de') {
				$opcodes->add(Opcode->new(asm=>"ld ($rp), a", cpu=>$cpu, 
										  ops=>[[0x02+16*RP($rp)]]));
			}
		}

		# LDAX rp
		for my $rp ('b', 'd') {
			$opcodes->add(Opcode->new(asm=>"ldax $rp", cpu=>$cpu, 
									  ops=>[[0x0A+16*RP($rp)]]));
		}
		if (!$strict) {
			for my $rp ('bc', 'de') {
				$opcodes->add(Opcode->new(asm=>"ldax $rp", cpu=>$cpu, 
										  ops=>[[0x0A+16*RP($rp)]]));
			}
		}

		# LD A, (rp)
		if (!$strict) {
			for my $rp ('bc', 'de') {
				$opcodes->add(Opcode->new(asm=>"ld a, ($rp)", cpu=>$cpu, 
										  ops=>[[0x0A+16*RP($rp)]]));
			}
		}

		# STA
		$opcodes->add(Opcode->new(asm=>"sta %m", cpu=>$cpu, 
								  ops=>[[0x32, '%m', '%m']]));

		# LD (NN), A
		if (!$strict) {
			$opcodes->add(Opcode->new(asm=>"ld (%m), a", cpu=>$cpu, 
									  ops=>[[0x32, '%m', '%m']]));
		}

		# LDA
		$opcodes->add(Opcode->new(asm=>"lda %m", cpu=>$cpu, 
								  ops=>[[0x3A, '%m', '%m']]));

		# LD A, (NN)
		if (!$strict) {
			$opcodes->add(Opcode->new(asm=>"ld a, (%m)", cpu=>$cpu, 
									  ops=>[[0x3A, '%m', '%m']]));
		}

		# SHLD
		$opcodes->add(Opcode->new(asm=>"shld %m", cpu=>$cpu, 
								  ops=>[[0x22, '%m', '%m']]));

		# LD (NN), HL
		if (!$strict) {
			$opcodes->add(Opcode->new(asm=>"ld (%m), hl", cpu=>$cpu, 
									  ops=>[[0x22, '%m', '%m']]));
		}

		# LHLD
		$opcodes->add(Opcode->new(asm=>"lhld %m", cpu=>$cpu, 
								  ops=>[[0x2A, '%m', '%m']]));

		# LD HL, (NN)
		if (!$strict) {
			$opcodes->add(Opcode->new(asm=>"ld hl, (%m)", cpu=>$cpu, 
									  ops=>[[0x2A, '%m', '%m']]));
		}

		# EX DE, HL
		add_ex_de_hl_8080($opcodes, $cpu);
		add_ex_de_hl_z80($opcodes, $cpu) if !$strict;

		# PUSH/POP rp
		add_push_pop_rp_8080($opcodes, $cpu);
		add_push_pop_rp_z80($opcodes, $cpu) if !$strict;

		# XTHL
		$opcodes->add(Opcode->new(asm=>"xthl", cpu=>$cpu, 
								  ops=>[[0xE3]]));

		# EX (SP), HL
		if (!$strict) {
			$opcodes->add(Opcode->new(asm=>"ex (sp), hl", cpu=>$cpu, 
									  ops=>[[0xE3]]));
		}

		# SPHL
		$opcodes->add(Opcode->new(asm=>"sphl", cpu=>$cpu, 
								  ops=>[[0xF9]]));

		# LD SP, HL
		if (!$strict) {
			$opcodes->add(Opcode->new(asm=>"ld sp, hl", cpu=>$cpu, 
									  ops=>[[0xF9]]));
		}

		# Jump
		#add_jumps_8080($opcodes, $cpu, $strict);	# do jp if strict
		#add_jumps_z80($opcodes, $cpu) if !$strict;

		# JMP NN
		$opcodes->add(Opcode->new(asm=>"jmp %m", cpu=>$cpu, 
								  ops=>[[0xC3, '%m', '%m']]));
								  
		# JP NN
		if (!$strict) {
			$opcodes->add(Opcode->new(asm=>"jp %m", cpu=>$cpu, 
									  ops=>[[0xC3, '%m', '%m']]));
		}

		# J<FLAG> NN
		for my $flag ('nz', 'z', 'nc', 'c', 'po', 'pe', 'p', 'm') {
			if ($strict || $flag ne 'p') {
				$opcodes->add(Opcode->new(asm=>"j$flag %m", cpu=>$cpu, 
										  ops=>[[0xC2+8*F($flag), '%m', '%m']]));
			}
			if (!$strict) {
				$opcodes->add(Opcode->new(asm=>"j_$flag %m", cpu=>$cpu, 
										  ops=>[[0xC2+8*F($flag), '%m', '%m']]));
			}
		}

		# JP FLAG, NN
		if (!$strict) {
			for my $jump ('jp', 'jmp') {
				for my $flag ('nz', 'z', 'nc', 'c', 'po', 'pe', 'p', 'm') {
					$opcodes->add(Opcode->new(asm=>"$jump $flag, %m", cpu=>$cpu, 
											  ops=>[[0xC2+8*F($flag), '%m', '%m']]));
				}
			}
		}

		# PCHL
		$opcodes->add(Opcode->new(asm=>"pchl", cpu=>$cpu, 
								  ops=>[[0xE9]]));

		# JP (HL)
		if (!$strict) {
			for my $jump ('jp', 'jmp') {
				$opcodes->add(Opcode->new(asm=>"$jump (hl)", cpu=>$cpu, 
										  ops=>[[0xE9]]));
			}
		}

		# CALL NN
		$opcodes->add(Opcode->new(asm=>"call %m", cpu=>$cpu, 
								  ops=>[[0xCD, '%m', '%m']]));

		# C<FLAG> NN
		for my $flag ('nz', 'z', 'nc', 'c', 'po', 'pe', 'p', 'm') {
			if ($strict || $flag ne 'p') {
				$opcodes->add(Opcode->new(asm=>"c$flag %m", cpu=>$cpu, 
										  ops=>[[0xC4+8*F($flag), '%m', '%m']]));
			}
			if (!$strict) {
				$opcodes->add(Opcode->new(asm=>"c_$flag %m", cpu=>$cpu, 
										  ops=>[[0xC4+8*F($flag), '%m', '%m']]));
			}
		}

		# CALL FLAG, NN
		if (!$strict) {
			for my $flag ('nz', 'z', 'nc', 'c', 'po', 'pe', 'p', 'm') {
				$opcodes->add(Opcode->new(asm=>"call $flag, %m", cpu=>$cpu, 
										  ops=>[[0xC4+8*F($flag), '%m', '%m']]));
			}
		}

		# RET
		$opcodes->add(Opcode->new(asm=>"ret", cpu=>$cpu, 
								  ops=>[[0xC9]]));

		# R<FLAG>
		for my $flag ('nz', 'z', 'nc', 'c', 'po', 'pe', 'p', 'm') {
			$opcodes->add(Opcode->new(asm=>"r$flag", cpu=>$cpu, 
									  ops=>[[0xC0+8*F($flag)]]));
			if (!$strict) {
				$opcodes->add(Opcode->new(asm=>"r_$flag", cpu=>$cpu, 
										  ops=>[[0xC0+8*F($flag)]]));
			}
		}

		# RET FLAG
		if (!$strict) {
			for my $flag ('nz', 'z', 'nc', 'c', 'po', 'pe', 'p', 'm') {
				$opcodes->add(Opcode->new(asm=>"ret $flag", cpu=>$cpu, 
										  ops=>[[0xC0+8*F($flag)]]));
			}
		}
		
		# RST NN
		$opcodes->add(Opcode->new(asm=>"rst %c", cpu=>$cpu, 
					  const=>[sort {$a<=>$b} 0, 8, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38],
					  ops=>[["0xC7+(%c<8?%c*8:%c)"]]));
					  
		# ALU [A,] r
		add_alu8_r_8080($opcodes, $cpu);
		add_alu8_r_z80($opcodes, $cpu) if !$strict;

		# ALU N
		add_alu8_N_8080($opcodes, $cpu);
		add_alu8_N_z80($opcodes, $cpu) if !$strict;

		# ADD rp
		add_add16_rp1_8080($opcodes, $cpu);
		add_add16_rp2_8080($opcodes, $cpu) if !$strict;
		add_add16_rp_z80($opcodes, $cpu) if !$strict;

		# Rotate
		$opcodes->add(Opcode->new(asm=>"rlc", cpu=>$cpu, 
								  ops=>[[0x07]]));
		$opcodes->add(Opcode->new(asm=>"rrc", cpu=>$cpu, 
								  ops=>[[0x0F]]));
		$opcodes->add(Opcode->new(asm=>"ral", cpu=>$cpu, 
								  ops=>[[0x17]]));
		$opcodes->add(Opcode->new(asm=>"rar", cpu=>$cpu, 
								  ops=>[[0x1F]]));
		
		if (!$strict) {
			$opcodes->add(Opcode->new(asm=>"rlca", cpu=>$cpu, 
									  ops=>[[0x07]]));
			$opcodes->add(Opcode->new(asm=>"rrca", cpu=>$cpu, 
									  ops=>[[0x0F]]));
			$opcodes->add(Opcode->new(asm=>"rla", cpu=>$cpu, 
									  ops=>[[0x17]]));
			$opcodes->add(Opcode->new(asm=>"rra", cpu=>$cpu, 
									  ops=>[[0x1F]]));
		}
		
		# Specials
		$opcodes->add(Opcode->new(asm=>"daa", cpu=>$cpu, 
								  ops=>[[0x27]]));
		$opcodes->add(Opcode->new(asm=>"cma", cpu=>$cpu, 
								  ops=>[[0x2F]]));
		$opcodes->add(Opcode->new(asm=>"stc", cpu=>$cpu, 
								  ops=>[[0x37]]));
		$opcodes->add(Opcode->new(asm=>"cmc", cpu=>$cpu, 
								  ops=>[[0x3F]]));

		if (!$strict) {
			$opcodes->add(Opcode->new(asm=>"cpl", cpu=>$cpu, 
									  ops=>[[0x2F]]));
			$opcodes->add(Opcode->new(asm=>"cpl a", cpu=>$cpu, 
									  ops=>[[0x2F]]));
			$opcodes->add(Opcode->new(asm=>"scf", cpu=>$cpu, 
									  ops=>[[0x37]]));
			$opcodes->add(Opcode->new(asm=>"ccf", cpu=>$cpu, 
									  ops=>[[0x3F]]));
		}

		# Input/Output
		$opcodes->add(Opcode->new(asm=>"out %n", cpu=>$cpu, 
								  ops=>[[0xD3, '%n']]));
		$opcodes->add(Opcode->new(asm=>"in %n", cpu=>$cpu, 
								  ops=>[[0xDB, '%n']]));
		
		if (!$strict) {
			$opcodes->add(Opcode->new(asm=>"out (%n), a", cpu=>$cpu, 
									  ops=>[[0xD3, '%n']]));
			$opcodes->add(Opcode->new(asm=>"in a, (%n)", cpu=>$cpu, 
									  ops=>[[0xDB, '%n']]));
		}
	
		# Control
		$opcodes->add(Opcode->new(asm=>"nop", cpu=>$cpu, 
								  ops=>[[0x00]]));
		$opcodes->add(Opcode->new(asm=>"hlt", cpu=>$cpu, 
								  ops=>[[0x76]]));
		$opcodes->add(Opcode->new(asm=>"di", cpu=>$cpu, 
								  ops=>[[0xF3]]));
		$opcodes->add(Opcode->new(asm=>"ei", cpu=>$cpu, 
								  ops=>[[0xFB]]));
		
		if (!$strict) {
			$opcodes->add(Opcode->new(asm=>"halt", cpu=>$cpu, 
									  ops=>[[0x76]]));
		}
	}
}
}

1;
