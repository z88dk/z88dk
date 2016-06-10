;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, MAR 2010
;
;	int zx_zxmmc();
;
;	The result is:
;	- 0 (false) zxmmc interface is not present
;	- 1 DISCiPle is installed
;
;	$Id: zx_zxmmc.asm,v 1.3 2016-06-10 20:02:05 dom Exp $
;

	SECTION code_clib
	PUBLIC	zx_zxmmc
	PUBLIC	_zx_zxmmc
	INCLUDE "zxmmc.def"

fast_save:	defb	0
	
zx_zxmmc:
_zx_zxmmc:
	di
	in a,(FASTPAGE)		; FASTPAGE register is saved
	ld (fast_save),a
	ld	a,$C0				; RAM_BANK
	out (FASTPAGE),a
	ld	hl,0
	ld	a,(hl)
	ld	e,a
	cpl
	ld	(hl),a
	ld	a,(hl)
	cp	e
	ld	a,e
	ld	(hl),a
	ld	hl,0
	jr	z,nozxmmc
	inc	hl
nozxmmc:
	ld a,(fast_save)	; FASTPAGE register is restored
	out (FASTPAGE),a
	ei
	ret
