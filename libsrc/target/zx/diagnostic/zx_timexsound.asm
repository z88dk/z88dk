;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 15/09/2006
;
;	int zx_timexsound();
;
;	The result is:
;	- 1 (true) if a sound chip on the TS2068 standard location is present
;	- 0 (false) otherwise
;
;	$Id: zx_timexsound.asm,v 1.3 2016-06-10 20:02:05 dom Exp $
;

	SECTION code_clib
	PUBLIC	zx_timexsound
	PUBLIC	_zx_timexsound
	
zx_timexsound:
_zx_timexsound:
	ld	hl,0
	ld	a,11		; envelope register
	out	($f6),a

	in	a,($f5)
	ld	e,a

	xor	170
	out	($f5),a
	ld	d,a
	in	a,($f5)
	cp	d

	ld	a,e
	out	($f5),a		; restore original value
	jr	nz,testend
	ret	nz

	inc	hl

testend:
	ld	a,($5c48)	; border
	and	$38
	rrc	a
	rrc	a
	rrc	a
	or	8
	out	(254),a
	ret
