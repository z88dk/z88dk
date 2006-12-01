;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 14/09/2006
;
;	int zx_trd();
;
;	The result is:
;	- 1 (true) if the TrDOS has been already enabled
;	- 0 (false) otherwise
;
;	$Id: zx_trd.asm,v 1.1 2006-12-01 16:58:30 stefano Exp $
;

	XLIB	zx_trd
	
zx_trd:
	ld	hl,(23737)
	ld	de,9761
	scf
	ccf
	sbc	hl,de
	ld	a,h
	or	l
	ld	hl,0
	ret	z

; OK, It is NOT an IF1, now check for RET in 23746
	ld	a,(23746)
	cp	201
	ret	nz
	inc	hl
	
	ret
