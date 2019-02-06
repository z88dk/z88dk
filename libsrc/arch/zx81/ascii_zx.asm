;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	convert ASCII character to ZX81 char code
;
;	char ascii_zx(char character);
;
;
;	$Id: ascii_zx.asm,v 1.5 2016-06-26 20:32:08 dom Exp $
;	

SECTION code_clib
PUBLIC	ascii_zx
PUBLIC	_ascii_zx
EXTERN	asctozx81

ascii_zx:
_ascii_zx:
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
