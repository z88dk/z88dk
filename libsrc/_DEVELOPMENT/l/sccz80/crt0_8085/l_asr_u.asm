; sccz80 crt0 library - 8085 version

SECTION code_crt0_sccz80

PUBLIC  l_asr_u
PUBLIC  l_asr_u_hl_by_e

.l_asr_u
    ex de,hl
.l_asr_u_hl_by_e
    dec e
    ret M

.l_asr_u_1
    ld a,h
    and a
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    dec e
    jp P,l_asr_u_1
    ret
