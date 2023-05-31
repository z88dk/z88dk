; ----- void __CALLEE__ xordrawr_callee(int x, int y)

    SECTION code_graphics
    PUBLIC  xordrawr_callee
    PUBLIC  _xordrawr_callee
    PUBLIC  asm_xordrawr
    
    EXTERN  __v1050_line
    EXTERN  __gfx_coords

    INCLUDE "graphics/grafix.inc"

.xordrawr_callee
._xordrawr_callee
    pop     af
    pop     de
    pop     hl
    push    af

; de = x1, hl = y1, hl'=x2, de'=y2
.asm_xordrawr
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

    ld      c,'8'
    jp    __v1050_line
