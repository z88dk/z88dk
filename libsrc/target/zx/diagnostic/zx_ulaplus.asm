;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, MAR 2010
;
;	int zx_ulaplus();
;
;	The result is:
;	- 0 (false) ULAPlus not installed / emulated
;	- 1 ULAPlus 64 colour mode is available
;
;	$Id: zx_ulaplus.asm,v 1.4 2016-06-10 20:02:05 dom Exp $
;

	SECTION code_clib
	PUBLIC	zx_ulaplus
	PUBLIC	_zx_ulaplus

zx_ulaplus:
_zx_ulaplus:
	; Enter in 64 colour mode
	ld	bc,$bf3b
	ld	a,64	; select mode group (01xxxxxx)
	out	(c),a

	ld	b,$ff
	in	a,(c)
	ld	e,a
	
	ld	a,1		; palette mode
	out	(c),a

	in	a,(c)	; see if ULAPlus got palette mode	
	dec	a
	ld	hl,0
	ret	nz

	ld	a,e
	out	(c),a	; restore current palette mode

	inc	hl
	ret
