;
; 	ANSI Video handling for the ZX81, HR interlaced graphics mode
;	By Stefano Bodrato - Apr. 2025
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup_wrxi.asm
;

    SECTION code_clib
    PUBLIC  ansi_SCROLLUP
    EXTERN  ansi_del_line
    EXTERN  base_graphics
    EXTERN  __console_h


ansi_SCROLLUP:
    ld      hl, (base_graphics)

    push    hl
    ld      de, 192
    add     hl, de
    pop     de

;    ld      a, (__console_h)
;    dec     a

    ld      bc, 6144*2-192
    ldir

	ld	a,(__console_h)
	dec	a
    call    ansi_del_line
    ret
