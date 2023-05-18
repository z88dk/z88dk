; ----- void __CALLEE__ xordrawto_callee(int x, int y)

    SECTION code_graphics
    PUBLIC  xordrawto_callee
    PUBLIC  _xordrawto_callee
    PUBLIC  asm_xordrawto

    EXTERN  __v1050_line
    EXTERN  __gfx_coords

    INCLUDE "graphics/grafix.inc"

.xordrawto_callee
._xordrawto_callee
    pop     af
    pop     de
    pop     hl
    push    af

; de = x1, hl = y1, hl'=x2, de'=y2
.asm_xordrawto
    exx
    ld      de,(__gfx_coords+2)
    ld      hl,(__gfx_coords)

	ld      c,'8'
    jp    __v1050_line
