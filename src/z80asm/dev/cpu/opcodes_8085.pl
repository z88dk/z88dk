#------------------------------------------------------------------------------
# 8085
#------------------------------------------------------------------------------

for my $cpu1 ('8085') {
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

		# EX DE, HL
		add_ex_de_hl_8080($opcodes, $cpu);
		add_ex_de_hl_z80($opcodes, $cpu) if !$strict;

		# PUSH/POP rp
		add_push_pop_rp_8080($opcodes, $cpu);
		add_push_pop_rp_z80($opcodes, $cpu) if !$strict;

		# add 8085
		$opcodes->add(Opcode->new(asm=>"rim", cpu=>$cpu, 
								  ops=>[[0x20]]));
		$opcodes->add(Opcode->new(asm=>"sim", cpu=>$cpu, 
								  ops=>[[0x30]]));
								  
		# add undocumented 8080
		if (!$strict) {
			# 16-bit subtract
			for my $asm ("dsub", "sub hl, bc") {
				$opcodes->add(Opcode->new(asm=>$asm, cpu=>$cpu, 
										  ops=>[[0x08]]));
			}
			
			# Rotate HL right
			for my $asm ("arhl", "rrhl", "sra hl") {
				$opcodes->add(Opcode->new(asm=>$asm, cpu=>$cpu, 
										  ops=>[[0x10]]));
			}
			
			# Rotate DE left
			for my $asm ("rdel", "rlde", "rl de") {
				$opcodes->add(Opcode->new(asm=>$asm, cpu=>$cpu, 
										  ops=>[[0x18]]));
			}
			
			# LD DE, HL+u
			# Add 00bb immediate to HL, result to DE (undocumented i8085)
			for my $asm ("ldhi %n", "adi hl, %n") {
				$opcodes->add(Opcode->new(asm=>$asm, cpu=>$cpu, 
										  ops=>[[0x28, '%n']]));
			}
			for my $asm ("ld de, hl+%u") {
				$opcodes->add(Opcode->new(asm=>$asm, cpu=>$cpu, 
										  ops=>[[0x28, '%u']]));
			}

			# LD DE, SP+u
			# Add 00bb immediate to SP, result to DE
			for my $asm ("ldsi %n", "adi sp, %n") {
				$opcodes->add(Opcode->new(asm=>$asm, cpu=>$cpu, 
										  ops=>[[0x38, '%n']]));
			}
			for my $asm ("ld de, sp+%u") {
				$opcodes->add(Opcode->new(asm=>$asm, cpu=>$cpu, 
										  ops=>[[0x38, '%u']]));
			}
			$opcodes->add(Opcode->new(asm=>"ld de, sp", cpu=>$cpu, 
									  ops=>[[0x38, 0]]));

			# LD HL, SP+u
			$opcodes->add(Opcode->new(asm=>"ld hl, sp+%u", cpu=>$cpu, 
									  ops=>[[0xEB], [0x38, '%u'], [0xEB]],
									  synth=>1));
			$opcodes->add(Opcode->new(asm=>"ld hl, sp", cpu=>$cpu, 
									  ops=>[[0xEB], [0x38, 0], [0xEB]],
									  synth=>1));
			
			# Restart 8 (0040) if V flag is set
			for my $asm ("rstv", "ovrst8") {
				$opcodes->add(Opcode->new(asm=>$asm, cpu=>$cpu, 
										  ops=>[[0xCB]]));
			}
			for my $asm ("rst v, %c") {
				$opcodes->add(Opcode->new(asm=>$asm, cpu=>$cpu, 
										  const=>[0x40],
										  ops=>[[0xCB]]));
			}
			
			# Store HL at address pointed by DE
			for my $asm ("shlx", "shlde", "ld (de), hl") {
				$opcodes->add(Opcode->new(asm=>$asm, cpu=>$cpu, 
										  ops=>[[0xD9]]));
			}
			
			# Jump on flag X5/K
			for my $asm ("jx5 %m", "jk %m", 
						 "jp x5, %m", "jp k, %m", 
						 "jmp x5, %m", "jmp k, %m", ) {
				$opcodes->add(Opcode->new(asm=>$asm, cpu=>$cpu, 
										  ops=>[[0xFD, '%m', '%m']]));
			}
			
			for my $asm ("jnx5 %m", "jnk %m", 
						 "jp nx5, %m", "jp nk, %m", 
						 "jmp nx5, %m", "jmp nk, %m") {
				$opcodes->add(Opcode->new(asm=>$asm, cpu=>$cpu, 
										  ops=>[[0xDD, '%m', '%m']]));
			}
			
			# Load HL from address pointed by DE
			for my $asm ("lhlx", "lhlde", "ld hl, (de)") {
				$opcodes->add(Opcode->new(asm=>$asm, cpu=>$cpu, 
										  ops=>[[0xED]]));
			}
		}
	}
}
}

1;
