
                SECTION   code_crt0_sccz80
                PUBLIC    l_asr
		PUBLIC	  l_asr_hl_by_e

.l_asr
        ld      a,l
        ld      l,e
        ld      h,d
        ld      e,a
.l_asr_hl_by_e
        ld      a,e
.l_asr1
        and     15
        ret     z
        sra     h
        rr      l
        dec     a
        jp      l_asr1

