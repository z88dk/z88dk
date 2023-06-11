; ----- void __CALLEE__ drawto_callee(int x, int y)

    SECTION code_graphics
    PUBLIC  drawto_callee
    PUBLIC  _drawto_callee
    PUBLIC  asm_drawto

    EXTERN  __mbc_line
    EXTERN  __gfx_coords

    INCLUDE "graphics/grafix.inc"

.drawto_callee
._drawto_callee
    pop     af
    pop     de
    pop     hl
    push    af

; de = x1, hl = y1, hl'=x2, de'=y2
.asm_drawto
    exx
    ld      de,(__gfx_coords+2)
    ld      hl,(__gfx_coords)

    ld      c,'0'
    jp    __mbc_line
