; ----- void __CALLEE__ drawr_callee(int x, int y)

    SECTION code_graphics
    PUBLIC  drawr_callee
    PUBLIC  _drawr_callee
    PUBLIC  asm_drawr
    
    EXTERN  __mbc_line
    EXTERN  __gfx_coords

    INCLUDE "graphics/grafix.inc"

.drawr_callee
._drawr_callee
    pop     af
    pop     de
    pop     hl
    push    af

; de = x1, hl = y1, hl'=x2, de'=y2
.asm_drawr
    push    hl
    push    de
    exx

    ; Y'
    pop     bc
    ld      hl,(__gfx_coords+2)
    add     hl,bc
    ex      de,hl
	
    ; X'
    pop     bc
    ld      hl,(__gfx_coords)
    add     hl,bc
    exx

    ld      hl,(__gfx_coords)
    ld      de,(__gfx_coords+2)

    ld      c,'0'
    jp    __mbc_line
