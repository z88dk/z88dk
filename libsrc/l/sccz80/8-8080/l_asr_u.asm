; sccz80 crt0 library - 8080 version

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_asr_u
PUBLIC  l_asr_u_hl_by_e

.l_asr_u
    ex      de,hl
.l_asr_u_hl_by_e
.l_asr_u_1
    dec     e
    ret     M

    ld      a,h
    and     a
    rra
    ld      h,a
    ld      a,l
    rra
    ld      l,a
    jp      l_asr_u_1
