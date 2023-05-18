; ----- void __CALLEE__ undrawto_callee(int x, int y)

    SECTION code_graphics
    PUBLIC  undrawto_callee
    PUBLIC  _undrawto_callee
    PUBLIC  asm_undrawto

    EXTERN  __v1050_line
    EXTERN  __gfx_coords

    INCLUDE "graphics/grafix.inc"

.undrawto_callee
._undrawto_callee
    pop     af
    pop     de
    pop     hl
    push    af

; de = x1, hl = y1, hl'=x2, de'=y2
.asm_undrawto
    exx
    ld      de,(__gfx_coords+2)
    ld      hl,(__gfx_coords)

	ld      c,'1'
    jp    __v1050_line
