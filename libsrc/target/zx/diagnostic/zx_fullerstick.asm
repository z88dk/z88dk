;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 14/09/2006
;
;	int zx_fullerstick();
;
;	The result is:
;	- 1 (true) if a fuller Joystickstick is present
;	- 0 (false) otherwise
;
;	$Id: zx_fullerstick.asm,v 1.3 2016-06-10 20:02:05 dom Exp $
;

	SECTION code_clib
	PUBLIC	zx_fullerstick
	PUBLIC	_zx_fullerstick
	
zx_fullerstick:
_zx_fullerstick:
	ld	hl,0
	ld	bc,65535
loop:
	in	a,($7f)
	cp	255
	ret	nz
	dec	bc
	ld	a,b
	or	c
	jr	nz,loop
	
	inc	hl
	ret
