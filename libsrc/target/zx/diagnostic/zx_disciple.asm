;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 11/08/2006
;
;	int zx_disciple();
;
;	The result is:
;	- 0 (false) DISCiPle-like interface is not present
;	- 1 DISCiPle is installed
;	- 2 +D is installer
;
;	$Id: zx_disciple.asm,v 1.3 2016-06-10 20:02:05 dom Exp $
;

	SECTION code_clib
	PUBLIC	zx_disciple
	PUBLIC	_zx_disciple
	
zx_disciple:
_zx_disciple:
	ld	a,170
	out	($5b),a
	in	a,($5b)
	ld	hl,1
	cp	170
	ret	z
	
	ld	a,170
	out	($eb),a
	in	a,($eb)
	inc	hl
	cp	170
	ret	z
	
	ld	l,0
	ret
