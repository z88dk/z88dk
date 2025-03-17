#------------------------------------------------------------------------------
# gbz80
#------------------------------------------------------------------------------

for my $cpu1 ('gbz80') {
	for my $strict ('', '_strict') {
		my $cpu = $cpu1.$strict;

		add_mov_r_r($cpu) if !$strict;
		add_ld_r_r($cpu);

        add_mvi_r_N($cpu) if !$strict;
        add_ld_r_N($cpu);
		
        add_lda_sta($cpu) if !$strict;
        add_ld_a_iNN($cpu);
        
		add_ldax_stax_r($cpu) if !$strict;
        add_ldax_stax_rp($cpu) if !$strict;
        add_ld_a_ibc($cpu);
        
		add_ld_a_ic_gbz80($cpu);
		add_ld_a_hli_hld_gbz80($cpu);
		add_ldh_a_iN_gbz80($cpu);
		
		add_lxi_r_NN($cpu) if !$strict;
        add_lxi_rp_NN($cpu) if !$strict;
        add_ld_rp_NN($cpu);
        
		add_sphl($cpu) if !$strict;
		add_ld_sp_hl($cpu);

		add_ld_hl_sp_plus_s_gbz80($cpu);
		add_ld_iNN_sp_gbz80($cpu);

        add_push_pop_r($cpu) if !$strict;
        add_push_pop_rp($cpu);
        
		add_alu_r_8080($cpu) if !$strict;
		add_alu_r_z80($cpu);
		add_alu_r_extra($cpu) if !$strict;
		
		add_alu_N_8080($cpu) if !$strict;
		add_alu_N_z80($cpu);
		add_alu_N_extra($cpu) if !$strict;
		
		add_inr_dcr_r($cpu) if !$strict;
		add_inc_dec_r($cpu);

		add_dad_r($cpu) if !$strict;
		add_dad_rp($cpu) if !$strict;
		add_add_hl_rp($cpu);
		
		add_add_sp_s_gbz80($cpu);

		add_inx_dcx_r($cpu) if !$strict;
		add_inx_dcx_rp($cpu) if !$strict;
		add_inc_dec_rp($cpu);

		add_daa($cpu);

		add_cma($cpu) if !$strict;
		add_cpl($cpu);
		add_cpl_a($cpu) if !$strict;

		add_cmc($cpu) if !$strict;
		add_ccf($cpu);
		add_stc($cpu) if !$strict;
		add_scf($cpu);

		add_nop($cpu);

		add_hlt($cpu) if !$strict;
		add_halt($cpu);
		add_stop_gbz80($cpu);

		add_ei_di($cpu);

		add_rot_a_8080($cpu) if !$strict;
		add_rot_a_z80($cpu);
		
		add_rot_z80($cpu);
		add_swap_gbz80($cpu);
		add_bit_res_set_z80($cpu);

		add_jmp($cpu) if !$strict;
		add_jp($cpu);

		add_jflag($cpu) if !$strict;
		add_j_flag($cpu) if !$strict;
		add_jp_8080($cpu) if 0;
		add_jp_flag($cpu);
		add_jmp_flag($cpu) if !$strict;

        add_pchl($cpu) if !$strict;
        add_jp_hl($cpu);
        add_jmp_hl($cpu) if !$strict;

		add_jr($cpu);
		add_jr_flag($cpu);

		add_call($cpu);
		add_cflag($cpu) if !$strict;
		add_c_flag($cpu) if !$strict;
		add_call_flag($cpu);

		add_rst($cpu);
		
		add_ret($cpu);
		add_rflag($cpu) if !$strict;
		add_r_flag($cpu) if !$strict;
		add_ret_flag($cpu);
		add_reti($cpu);
    }
}

1;
