;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, MAR 2010
;
;	int ula_plus_mode();
;
;	The result is:
;	- 0 (false) ULAPlus not installed / emulated
;	- 1 ULAPlus 64 colour mode is available
;
;	$Id: ula_plus_mode.asm,v 1.3 2016-06-10 21:14:23 dom Exp $
;

	SECTION code_clib
	PUBLIC	ula_plus_mode
	PUBLIC	_ula_plus_mode

ula_plus_mode:
_ula_plus_mode:
	; Enter in 64 colour mode
	ld	bc,$bf3b
	ld	a,64	; select mode group (01xxxxxx)
	out	(c),a

	ld	b,$ff	
	ld	a,1		; palette mode
	out	(c),a

	in	a,(c)	; see if ULAPlus got palette mode
	dec	a
	
	ld	hl,0
	ret	nz

	inc	hl
	ret
