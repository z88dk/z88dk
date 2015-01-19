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
;	$Id: zx_extsys.asm,v 1.3 2015-01-19 01:33:07 pauloscustodio Exp $
;

	PUBLIC	zx_extsys
	
zx_extsys:
	ld	hl,(23635)
	ld	de,23755
	and	a	; clears carry
	sbc	hl,de
	ret	z
	ld	hl,1
	ret
