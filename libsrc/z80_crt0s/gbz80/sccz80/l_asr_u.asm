
                SECTION   code_crt0_sccz80
                PUBLIC    l_asr_u
		PUBLIC    l_asr_u_hl_by_e

.l_asr_u
        ld      a,l
        ld      l,e
        ld      h,d
        ld      e,a
.l_asr_u_hl_by_e
        ld      a,e
.l_asr_u_1
        and     15
        ret     z
	srl	h
        rr      l
        dec     a
        jp      l_asr_u_1




