;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 14/09/2006
;	Optimized by Antonio Schifano, Dec 2008
;
;	int zx_extsys();
;
;	Check whether the BASIC program has been moved to leave space for 
;	extra system variables, normally added by some added interface.
;
;	The result is:
;	- 0 (false) the BASIC is at its normal position
;	- 1 (true) the BASIC program has been moved
;
;	$Id: zx_extsys.asm,v 1.4 2016-06-10 20:02:04 dom Exp $
;

        SECTION code_clib
	PUBLIC	zx_extsys
	PUBLIC	_zx_extsys
	
zx_extsys:
_zx_extsys:
	ld	hl,(23635)
	ld	de,23755
	and	a	; clears carry
	sbc	hl,de
	ret	z
	ld	hl,1
	ret
