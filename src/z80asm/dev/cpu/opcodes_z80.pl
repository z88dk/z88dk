#------------------------------------------------------------------------------
# z80
#------------------------------------------------------------------------------

for my $cpu1 ('z80') {
	for my $strict ('', '_strict') {
		my $cpu = $cpu1.$strict;
		
		add_mov_r_r($cpu) if !$strict;
        add_mvi_r_N($cpu) if !$strict;
		add_ld_r_r($cpu);
        add_ld_r_N($cpu);
        add_ld_ixh_r($cpu) if !$strict;
        add_ld_ixh_N($cpu) if !$strict;
        add_ld_r_idx($cpu);
        
		add_lxi_r_NN($cpu) if !$strict;
        add_lxi_rp_NN($cpu) if !$strict;
        add_ld_rp_NN($cpu);
        add_ld_ix_NN($cpu);

        add_lda_sta($cpu) if !$strict;
        add_ld_a_iNN($cpu);
        
        add_lhld_shld($cpu) if !$strict;
        add_ld_hl_iNN($cpu);
        add_ld_ix_iNN($cpu);

        add_ldax_stax_r($cpu) if !$strict;
        add_ldax_stax_rp($cpu) if !$strict;
        add_ld_a_ibc($cpu);
        
        add_xchg($cpu) if !$strict;
        add_ex_de_hl($cpu);
        
        add_pchl($cpu) if !$strict;
        add_jp_hl($cpu);
        add_jp_ix($cpu);

        add_push_pop_r($cpu) if !$strict;
        add_push_pop_rp($cpu);
        add_push_pop_ix($cpu);
        
if(0){
		# INC/DEC r
		add_inc_dec_r_8080($opcodes, $cpu) if !$strict;
		add_inc_dec_r_z80($opcodes, $cpu);

		# INC/DEC rp
		add_inc_dec_rp1_8080($opcodes, $cpu) if !$strict;
		add_inc_dec_rp2_8080($opcodes, $cpu) if !$strict;
		add_inc_dec_rp_z80($opcodes, $cpu);

		# ALU [A,] r
		add_alu8_r_8080($opcodes, $cpu) if !$strict;
		add_alu8_r_z80($opcodes, $cpu);
		add_alu8_idx($opcodes, $cpu);
		add_alu8_idx_lh($opcodes, $cpu) if !$strict;

		# ALU N
		add_alu8_N_8080($opcodes, $cpu) if !$strict;
		add_alu8_N_z80($opcodes, $cpu);

		# ADD rp
		add_add16_rp1_8080($opcodes, $cpu) if !$strict;
		add_add16_rp2_8080($opcodes, $cpu) if !$strict;
		add_add16_rp_z80($opcodes, $cpu);
		add_add16_idx($opcodes, $cpu);
		add_alu16_rp_z80($opcodes, $cpu);

		# EX DE, HL
		add_ex_de_hl_8080($opcodes, $cpu) if !$strict;
		add_ex_de_hl_z80($opcodes, $cpu);

		# PUSH/POP rp
		add_push_pop_rp_8080($opcodes, $cpu) if !$strict;
		add_push_pop_rp_z80($opcodes, $cpu);

		# ROT r
		add_rot_z80($opcodes, $cpu);
		add_rot_z80_undocumented($opcodes, $cpu) if !$strict;

		# BIT r
		add_bit_res_set_z80($opcodes, $cpu);
		add_bit_res_set_z80_idx($opcodes, $cpu);
	}
}
}

1;
