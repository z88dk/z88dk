;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	convert char to ASCII
;
;	char zx_ascii(char character);
;
;
;	$Id: zx_ascii.asm,v 1.5 2016-06-26 20:32:08 dom Exp $
;	

SECTION code_clib
PUBLIC	zx_ascii
PUBLIC	_zx_ascii
EXTERN	zx81toasc

zx_ascii:
_zx_ascii:
	ld	hl,zx81toasc+1
	ld	a,(hl)
	push	af
	push	hl

	ld	a,229		; push hl
	ld	(hl),a

	ld	hl,6
	add	hl,sp	; location of char
	call	zx81toasc
	
	pop	bc

	ld	h,0
	ld	l,a
	
	pop	af
	ld	(bc),a
	
	ret
