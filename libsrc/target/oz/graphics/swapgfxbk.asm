;
; Sharp OZ family port (graphics routines)
; Stefano Bodrato - Aug 2002
;
;       Page the graphics bank in/out - used by all gfx functions
;       Simply does a swap...
;
;
;	$Id: __gfx_vram_page_in.asm,v 1.4 2017-01-02 22:57:58 aralbrec Exp $
;

        PUBLIC  __gfx_vram_page_in
        PUBLIC  ___gfx_vram_page_in
        PUBLIC  __gfx_vram_page_out
        PUBLIC  ___gfx_vram_page_out

        EXTERN  ozactivepage

;.iysave		defw	0


__gfx_vram_page_in:
___gfx_vram_page_in:
        push    bc
        ld      bc, (ozactivepage)
        ld      a, c
        out     (3), a
        ld      a, b
        out     (4), a
        pop     bc
;	        ld	(iysave),iy
        ret

__gfx_vram_page_out:
___gfx_vram_page_out:
        ld      a, 7
        out     (3), a
        ld      a, 4
        out     (4), a                  ;; page in proper second page
;		ld	iy,(iysave)
        ret



