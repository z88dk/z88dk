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
;	$Id: zx_asciimode.asm,v 1.3 2015-01-19 01:33:26 pauloscustodio Exp $
;	

PUBLIC	zx_asciimode
EXTERN	asctozx81
EXTERN	zx81toasc

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
	ld	(hl),a
	ret
