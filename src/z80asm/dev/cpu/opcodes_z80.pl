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
        add_ld_idx_r($cpu);
        add_ld_idx_N($cpu);
		
		add_lxi_r_NN($cpu) if !$strict;
        add_lxi_rp_NN($cpu) if !$strict;
        add_ld_rp_NN($cpu);
        add_ld_ix_NN($cpu);

        add_lda_sta($cpu) if !$strict;
        add_ld_a_iNN($cpu);
        
        add_lhld_shld($cpu) if !$strict;
        add_ld_hl_iNN($cpu);
        add_ld_ix_iNN($cpu);
		add_ld_rp_iNN($cpu);

        add_ldax_stax_r($cpu) if !$strict;
        add_ldax_stax_rp($cpu) if !$strict;
        add_ld_a_ibc($cpu);
        
        add_xchg($cpu) if !$strict;
        add_ex_de_hl($cpu);
        
		add_alu_r_8080($cpu) if !$strict;
		add_alu_r_z80($cpu);
		add_alu_r_extra($cpu) if !$strict;
		
		add_alu_idx($cpu);
		add_alu_idx_extra($cpu) if !$strict;
		
		add_alu_ixh($cpu) if !$strict;
		add_alu_ixh_extra($cpu) if !$strict;
		
		add_alu_N_8080($cpu) if !$strict;
		add_alu_N_z80($cpu);
		add_alu_N_extra($cpu) if !$strict;
		
		add_inr_dcr_r($cpu) if !$strict;
		add_inc_dec_r($cpu);
		add_inc_dec_idx($cpu);
		add_inc_dec_ixh($cpu) if !$strict;
		
		add_inx_dcx_r($cpu) if !$strict;
		add_inx_dcx_rp($cpu) if !$strict;
		add_inc_dec_rp($cpu);
		add_inc_dec_ix($cpu);

		add_dad_r($cpu) if !$strict;
		add_dad_rp($cpu) if !$strict;
		add_add_hl_rp($cpu);
		add_add_ix_rp($cpu);
		add_adc_sbc_hl_rp($cpu);
		
		add_daa($cpu);
		add_cma($cpu) if !$strict;
		add_cpl($cpu);
		add_cmc($cpu) if !$strict;
		add_ccf($cpu);
		add_stc($cpu) if !$strict;
		add_scf($cpu);

		add_rot_a_8080($cpu) if !$strict;
		add_rot_a_z80($cpu);
		
		add_rot_z80($cpu);
		add_rot_z80_idx($cpu);
		add_rot_z80_undocumented($cpu) if !$strict;
		add_rot_z80_idx_undocumented($cpu) if !$strict;
		add_rot_idx_r_undocumented($cpu) if !$strict;
		add_bit_res_set_z80($cpu);
		add_bit_res_set_z80_idx($cpu);
		add_bit_res_set_z80_idx_r($cpu) if !$strict;
		
		add_jr($cpu);
		add_djnz($cpu);
		add_jr_flag($cpu);
		
		add_jmp($cpu) if !$strict;
		add_jp($cpu);
		add_jflag($cpu) if !$strict;
		add_j_flag($cpu) if !$strict;
		add_jp_8080($cpu) if 0;
		add_jp_flag($cpu);
		add_jmp_flag($cpu) if !$strict;
		
        add_pchl($cpu) if !$strict;
        add_jp_hl($cpu);
        add_jp_ix($cpu);
        add_jmp_hl($cpu) if !$strict;
        add_jmp_ix($cpu) if !$strict;

		add_call($cpu);
		add_cflag($cpu) if !$strict;
		add_c_flag($cpu) if !$strict;
		add_cp_8080($cpu) if 0;
		add_call_flag($cpu);
				
		add_ret($cpu);
		add_rflag($cpu) if !$strict;
		add_r_flag($cpu) if !$strict;
		add_ret_flag($cpu);
		
		add_rst($cpu);
		
        add_push_pop_r($cpu) if !$strict;
        add_push_pop_rp($cpu);
        add_push_pop_ix($cpu);
        
		add_xthl($cpu) if !$strict;
		add_ex_isp_hl($cpu);
		add_ex_isp_ix($cpu);

		add_sphl($cpu) if !$strict;
		add_ld_sp_hl($cpu);
		add_ld_sp_ix($cpu);
		
		add_in_N($cpu) if !$strict;
		add_in_a_N($cpu);
		add_out_N($cpu) if !$strict;
		add_out_N_a($cpu);
		add_in_r_c($cpu);
		add_in_r_c_extra($cpu) if !$strict;
		add_out_c_r($cpu);
		add_out_c_r_extra($cpu) if !$strict;
		add_in_out_undocumented($cpu) if !$strict;
		
		add_ei_di($cpu);
		add_hlt($cpu) if !$strict;
		add_halt($cpu);
		add_nop($cpu);
		
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
