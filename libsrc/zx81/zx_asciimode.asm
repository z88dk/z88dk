;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	Activates /deactivates the ZX81<->ASCII converter
;	mode=0       ..disable
;	other values ..enable
;
;	int __FASTCALL__ zx_asciimode(int mode);
;
;
;	$Id: zx_asciimode.asm,v 1.1 2007-10-25 14:53:04 stefano Exp $
;	

XLIB	zx_asciimode
LIB	asctozx81
LIB	zx81toasc

zx_asciimode:

	xor	a
	or	l
	ld	hl,asctozx81+1
	push	hl
	ld	hl,zx81toasc+1
	ld	a,201		; ret
	jr	z,off
on:	
	ld	a,229		; push hl
off:
	ld	(hl),a
	pop	hl
	ld	(hl),229
	ret
