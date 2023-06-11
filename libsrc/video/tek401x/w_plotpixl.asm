
        INCLUDE "graphics/grafix.inc"

	SECTION	  code_graphics
        PUBLIC    w_plotpixel

        EXTERN    getmaxx
        EXTERN    getmaxy
        EXTERN     l_cmp
        EXTERN     ___tek_plot

        EXTERN    __gfx_coords


; ******************************************************************
;
; Plot pixel at (x,y) coordinate.
;
; in:  hl,de    = (x,y) coordinate of pixel
.w_plotpixel
        push    hl
        call    getmaxy
        call    l_cmp
        pop     hl
        ret     nc               ; Return if Y overflows

        push    de
        ex      de,hl
        call    getmaxx
        ex      de,hl
        call    l_cmp
        pop     de
        ret     c                ; Return if X overflows
        
        ld      (__gfx_coords),hl      ; store X
        ld      (__gfx_coords+2),de    ; store Y: COORDS must be 2 bytes wider

        push    hl
        call    getmaxy
        and     a
        sbc     hl,de
        push    hl
        call    ___tek_plot
        pop     bc
        pop     bc
	ret
