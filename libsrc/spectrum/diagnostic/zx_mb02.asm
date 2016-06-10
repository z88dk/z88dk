;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 11/02/2008
;
;	int zx_mb02();
;
;	The result is:
;	- 0 (false) if MB-02 isn't connected
;	- 1 (true) if MB-02 real time clock is responding
;
;	$Id: zx_mb02.asm,v 1.3 2016-06-10 20:02:05 dom Exp $
;

	SECTION code_clib
	PUBLIC	zx_mb02
	PUBLIC	_zx_mb02
	
zx_mb02:
_zx_mb02:
	ld	bc,3
	in	a,(c)
	cp	10
	ld	hl,0
	ret	nc
	inc	hl
	ret
