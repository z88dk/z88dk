;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 14/09/2006
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
;	$Id: zx_extsys.asm,v 1.1 2008-06-29 08:25:46 aralbrec Exp $
;

	XLIB	zx_extsys
	
zx_extsys:
	ld	hl,(23635)
	ld	de,23755
	scf
	ccf
	sbc	hl,de
	ld	a,h
	or	l
	ld	hl,0
	ret	z
	inc	hl
	ret
