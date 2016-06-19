
        SECTION   code_clib
	PUBLIC	cleararea

        INCLUDE "cpcfirm.def"
        INCLUDE	"graphics/grafix.inc"

;
;	$Id: clrarea.asm,v 1.4 2016-06-19 21:10:08 dom Exp $
;

; ***********************************************************************
;
; Clear specified graphics area in map.
; Generic version
;
; Stefano Bodrato - March 2002
;
;
; IN:	HL	= (x,y)
;	BC	= (width,heigth)
;

.cleararea
		dec	b	; centered experimentally
		dec	b
		dec	b
		dec	c
		
		push	hl
		push	bc
		
		call    firmware
		defw    gra_get_w_width
		ld	(wwde+1),de
		ld	(wwhl+1),hl
		call    firmware
		defw    gra_get_w_height
		ld	(whde+1),de
		ld	(whhl+1),hl
		
		pop	bc
		pop	hl
		push	hl
		push	bc
		
		xor	a
		ld	l,h
		ld	e,b
		ld	h,a	; 0
		ld	d,a	; 0
		add	hl,hl
		push	hl
		add	hl,de
		add	hl,de
		pop	de
		ex	de,hl
		
		call    firmware
		defw    gra_win_width
		
		pop	de
		pop	bc
		ld	hl,maxy
		xor	a
		sbc	hl,bc
		
		;xor	a
		ld	h,a	; 0
		ld	d,a	; 0
		add	hl,hl
		push	hl
		sbc	hl,de
		sbc	hl,de
		pop	de
		ex	de,hl
		
		call    firmware
		defw    gra_win_height
		
		call    firmware
		defw    gra_clear_window

.wwde		ld	de,0
.wwhl		ld	hl,0
		call    firmware
		defw    gra_win_width

.whde		ld	de,0
.whhl		ld	hl,0
		call    firmware
		defw    gra_win_height

		ret
