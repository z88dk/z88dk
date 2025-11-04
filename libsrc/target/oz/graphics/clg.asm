;
; Sharp OZ family port (graphics routines)
; Stefano Bodrato - Aug 2002
;
;
;       Clear the graph. screen
;
;
;	$Id: clg.asm,v 1.5 2017-01-02 22:57:58 aralbrec Exp $
;


        PUBLIC  clg
        PUBLIC  _clg
        EXTERN  base_graphics

        EXTERN  __gfx_page_vram_in
        EXTERN  __gfx_page_vram_out

clg:
_clg:

        call    __gfx_page_vram_in

        ld      hl, (base_graphics)
        ld      d, h
        ld      e, l
        inc     de
        ld      bc, 2400-1
        xor     a
        ld      (hl), a
        ldir

        jp      __gfx_page_vram_out
