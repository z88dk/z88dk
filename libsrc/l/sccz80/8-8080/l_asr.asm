; sccz80 crt0 library - 8080 version

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_asr
PUBLIC  l_asr_hl_by_e

.l_asr
    ex      de,hl
.l_asr_hl_by_e
.l_asr1
    dec     e
    ret     M

    ld      a,h
    rla
    ld      a,h
    rra
    ld      h,a
    ld      a,l
    rra
    ld      l,a
    jp      l_asr1
