; Usage: circle(int x, int y, int radius, int skip);


    SECTION code_graphics
    
    PUBLIC  circle_callee
    PUBLIC  _circle_callee
    
    PUBLIC  asm_circle

    EXTERN  w_draw_circle
	EXTERN  __do_w_plot

    INCLUDE "graphics/grafix.inc"

    
.circle_callee
._circle_callee

;      de = x0, hl = y0, bc = radius, a = skip

    pop     af
    ex      af,af

    pop     de    ; skip
    ld      a,e
    pop     bc    ;radius
    pop     hl    ; y
    pop     de    ; x
    ex      af,af
    push    af
    ex      af,af

.asm_circle
    push    af
	ld      a,'S'
	ld      (__do_w_plot+1),a
    pop     af
    jp    w_draw_circle

