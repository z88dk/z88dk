;
; 	ANSI Video handling for the Commodore 128 (Z80 mode)
;	By Stefano Bodrato - 22/08/2001
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.1 2013-11-05 16:02:43 stefano Exp $
;

	XLIB	ansi_SCROLLUP


.ansi_SCROLLUP
	and	a
	ld	hl,$3000+40	; Text
	ld	de,40*24
scrloop:
	push de
	push hl
	ld	c,h
	ld	d,l
	in  a,(c)
	ld	de,40
	sbc	hl,de
	ld	c,h
	ld	d,l
	out (c),a
	pop hl
	pop de
	inc hl
	dec de
	ld  a,d
	or  e
	jr nz,scrloop
	
	ld	d,40
.reslloop
	ld	b,h
	ld	c,l
	ld	a,32
	out	(c),a
	inc	hl
	dec d
	jr nz,reslloop

;	ld	hl,$2000+40	; Color attributes
	ret
	
