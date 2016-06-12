;
; 	ANSI Video handling for the Commodore 128 (Z80 mode)
;	By Stefano Bodrato - 22/08/2001
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.6 2016-06-12 16:06:42 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_SCROLLUP


.ansi_SCROLLUP
	ld	hl,$2000+40	; Text
	ld	de,$2000
	ld	bc,40*24
	ldir
	ld	h,d
	ld	l,e
	ld	b,40
.reslloop
	ld	(hl),32
	inc	hl
	djnz	reslloop

	ld	hl,$1000+40	; Color attributes
	ld	de,$1000
	ld	bc,40*24
	ldir
	ld	h,d
	ld	l,e
	ld	b,40
.reslloop2
	ld	(hl),1
	inc	hl
	djnz	reslloop2

	ret

