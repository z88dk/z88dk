; sccz80 crt0 library - 8085 version

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

    sra     hl

    ld      a,$7f
    and     h
    ld      h,a

    jp      l_asr_u_1
