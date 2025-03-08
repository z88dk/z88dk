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
        
		add_alu_r_8080($cpu);
		add_alu_r_z80($cpu) if !$strict;
		add_alu_r_extra($cpu) if !$strict;
		
		add_alu_N_8080($cpu);
		add_alu_N_z80($cpu) if !$strict;
		add_alu_N_extra($cpu) if !$strict;
		
		add_inr_dcr_r($cpu);
		add_inc_dec_r($cpu) if !$strict;
		
		add_inx_dcx_r($cpu);
		add_inx_dcx_rp($cpu) if !$strict;
		add_inc_dec_rp($cpu) if !$strict;
		
		add_dad_r($cpu);
		add_dad_rp($cpu) if !$strict;
		add_add_hl_rp($cpu) if !$strict;
		
		add_daa($cpu);
		add_cma($cpu);
		add_cpl($cpu) if !$strict;
		add_cpl_a($cpu) if !$strict;
		add_cmc($cpu);
		add_ccf($cpu) if !$strict;
		add_stc($cpu);
		add_scf($cpu) if !$strict;
		
		add_rot_a_8080($cpu);
		add_rot_a_z80($cpu) if !$strict;
		
		add_jmp($cpu);
		add_jp($cpu) if !$strict;
		add_jflag($cpu);
		add_j_flag($cpu) if !$strict;
		add_jp_8080($cpu) if $strict;
		add_jp_flag($cpu) if !$strict;
		add_jmp_flag($cpu) if !$strict;
		
        add_pchl($cpu);
        add_jp_hl($cpu) if !$strict;
        add_jmp_hl($cpu) if !$strict;

		add_call($cpu);
		add_cflag($cpu);
		add_c_flag($cpu) if !$strict;
		add_cp_8080($cpu) if $strict;
		add_call_flag($cpu) if !$strict;
		
		add_ret($cpu);
		add_rflag($cpu);
		add_r_flag($cpu) if !$strict;
		add_ret_flag($cpu) if !$strict;
		
		add_rst($cpu);
		
        add_push_pop_r($cpu);
        add_push_pop_rp($cpu) if !$strict;

		add_xthl($cpu);
		add_ex_isp_hl($cpu) if !$strict;
		
		add_sphl($cpu);
		add_ld_sp_hl($cpu) if !$strict;
		
		add_in_N($cpu);
		add_in_a_N($cpu) if !$strict;
		add_out_N($cpu);
		add_out_N_a($cpu) if !$strict;
		
		add_ei_di($cpu);
		add_hlt($cpu);
		add_halt($cpu) if !$strict;
		add_nop($cpu);

        # 8085 specific
		add_rim_sim($cpu);

        # undocumented 8085
        if (!$strict) {
            add_dsub($cpu);
            add_arhl($cpu);
            add_rdel($cpu);
            add_ldhi_N($cpu);
            add_ldsi_N($cpu);
            add_rstv($cpu);
            add_shlx($cpu);
            add_jx5($cpu);
            add_lhlx($cpu);
        }	
    }
}

1;
