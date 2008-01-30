;
;	ZX Spectrum specific routines
;
;	int zx_interface1();
;
;	The result is:
;	- 0 (false) if the ZX Interface1 is missing or not paged in
;	- 1 (true) if the ZX Interface1 is connected and activated.
;
;	$Id: if1_installed.asm,v 1.2 2008-01-30 14:05:41 stefano Exp $
;

	XLIB	if1_installed
	
if1_installed:
	ld	hl,(23635)
	ld	de,23813
	sbc	hl,de
	ld	a,h
	or	l
	ld	hl,0
	ret	nz
	inc	hl
	ret
