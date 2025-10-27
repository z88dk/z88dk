
SECTION code_clib
SECTION code_l_sccz80
PUBLIC    l_asr_u
PUBLIC    l_asr_u_hl_by_e

.l_asr_u
    ld      a,l
    ld      l,e
    ld	e,a
    ld      h,d
.l_asr_u_hl_by_e
    ld	d,0
.l_asr_u_1
    dec	e
    ld	a,e
    inc	a
    ret     z
    srl	h
    rr      l
    jp      l_asr_u_1




