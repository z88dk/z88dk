;
; 	ANSI Video handling for the ZX81, HR interlaced graphics mode
;	By Stefano Bodrato - Apr. 2025
;
; 	Clean a text line
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline_wrxi.asm $
;

    SECTION code_clib
    PUBLIC  ansi_del_line
    EXTERN  base_graphics


ansi_del_line:

    ld      h, a
	ld      l, 0
	rr      h
	rr      l                          ; A*128
	add     h                          ; +A*256
	ld      h,a
	rr      h
	rr      l                          ; /2
    ld      de, (base_graphics)
    add     hl, de

    ld      (hl), 0
    ld      d, h
    ld      e, l
    inc     de

    ld      bc, 191

	push    hl

    ldir

	pop     hl
	ld      de,6144
	add     hl,de

    ld      (hl), 0
    ld      d, h
    ld      e, l
    inc     de

    ld      bc, 191

    ldir

    ret
