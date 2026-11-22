
SECTION code_clib
SECTION code_l_sccz80
PUBLIC    l_asr
PUBLIC	  l_asr_hl_by_e

.l_asr
    ld      a,l
    ld      l,e
    ld      h,d
    ld      e,a
.l_asr_hl_by_e
    ld      d,0
.l_asr1
    dec	e
    ld      a,e
    inc	a
    ret     z
    sra     h
    rr      l
    jp      l_asr1

