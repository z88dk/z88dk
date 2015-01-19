;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	convert ASCII character to ZX81 char code
;
;	char ascii_zx(char character);
;
;
;	$Id: ascii_zx.asm,v 1.4 2015-01-19 01:33:26 pauloscustodio Exp $
;	

PUBLIC	ascii_zx
EXTERN	asctozx81

ascii_zx:
	ld	hl,asctozx81+1
	ld	a,(hl)
	push	af
	push	hl

	ld	a,229		; push hl
	ld	(hl),a

	ld	hl,6
	add	hl,sp	; location of char
	call	asctozx81
	
	pop	bc

	ld	h,0
	ld	l,a
	
	pop	af
	ld	(bc),a
	
	ret
