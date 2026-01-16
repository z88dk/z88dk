;       Z88 Small C+ Run time Library
;       l_glong variant to be used sometimes by the peephole optimizer
;


SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_glong2sp
PUBLIC l_glong2sp_hlp

.l_glong2sp_hlp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a

; Fetch long from hl and push to stack
.l_glong2sp
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    ex      (sp),hl
    push    de
    jp      (hl)

