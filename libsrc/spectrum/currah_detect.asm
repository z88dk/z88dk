;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 30/06/2006
;
;	Currah uSpeech detection (TRUE or FALSE)
;	NOTE: this works for the 48K only
;
;	int currah_detect();
;
;
;	$Id: currah_detect.asm,v 1.1 2006-07-03 15:04:15 stefano Exp $
;

	XLIB	currah_detect
	
currah_detect:
	
	ld	bc,65365
	ld	hl,0	; false
	ld	a,(bc)
	inc	a
	ret	nz	; =255 ?
	
	dec	bc
	ld	a,(bc)
	dec	a
	dec	a
	and	224
	cp	64	; does it point to the currah buffer address range ?
	ret	nz
	
	inc	hl	; true
	ret
