; ----- void __CALLEE__ undrawr_callee(int x, int y)

    SECTION code_graphics
    PUBLIC  undrawr_callee
    PUBLIC  _undrawr_callee
    PUBLIC  asm_undrawr
    
    EXTERN  __mbc_line
    EXTERN  __gfx_coords

    INCLUDE "graphics/grafix.inc"

.undrawr_callee
._undrawr_callee
    pop     af
    pop     de
    pop     hl
    push    af

; de = x1, hl = y1, hl'=x2, de'=y2
.asm_undrawr
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

    ld      c,'1'
    jp    __mbc_line
