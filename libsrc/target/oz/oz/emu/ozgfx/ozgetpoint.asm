;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	int ozgetpoint(int x, int y);
;
; ------
; $Id: ozgetpoint.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
        PUBLIC  ozgetpoint
        PUBLIC  _ozgetpoint

        EXTERN  pointxy
        EXTERN  __gfx_vram_page_in


ozgetpoint:
_ozgetpoint:
        push    ix                      ;save callers
        ld      ix, 2
        add     ix, sp
        ld      l, (ix+2)
        ld      h, (ix+4)
        call    __gfx_vram_page_in
        call    pointxy
        ex      af, af'
        call    __gfx_vram_page_in
        ex      af, af'
        ld      hl, 0
        pop     ix
        ret     z                       ;pixel set
        inc     hl
        ret

