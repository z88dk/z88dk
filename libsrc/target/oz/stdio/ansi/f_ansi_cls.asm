;
; 	ANSI Video handling for Sharp OZ family
;
; 	CLS - Clear the text screen
;
;
;	Stefano Bodrato - Aug. 2002
;
;
;	$Id: f_ansi_cls.asm,v 1.5 2016-06-12 16:06:43 dom Exp $
;


    SECTION code_clib
    PUBLIC  ansi_cls
    EXTERN  base_graphics

    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out

ansi_cls:


    call    __gfx_vram_page_in

    ld      hl, (base_graphics)
    ld      d, h
    ld      e, l
    inc     de
    ld      bc, 2400-1
    xor     a
    ld      (hl), a
    ldir

    jp      __gfx_vram_page_out
