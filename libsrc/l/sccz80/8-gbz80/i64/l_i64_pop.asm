; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; sccz80 crt0 library - gbz80 version
; Pop the stacked long into __i64_acc. The first word is the high word.
; HL is preserved.

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_pop

EXTERN  __i64_acc

l_i64_pop:
    pop     de
    ld      bc,hl
    pop     hl
    ld      a,l
    ld      (__i64_acc+6),a
    ld      a,h
    ld      (__i64_acc+7),a
    pop     hl
    ld      a,l
    ld      (__i64_acc+4),a
    ld      a,h
    ld      (__i64_acc+5),a
    pop     hl
    ld      a,l
    ld      (__i64_acc+2),a
    ld      a,h
    ld      (__i64_acc+3),a
    pop     hl
    ld      a,l
    ld      (__i64_acc+0),a
    ld      a,h
    ld      (__i64_acc+1),a
    push    de
    ld      hl,bc
    ret
