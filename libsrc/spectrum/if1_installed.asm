;
;	ZX Spectrum specific routines
;
;	int zx_interface1();
;
;	The result is:
;	- 0 (false) if the ZX Interface1 is missing or not paged in
;	- 1 (true) if the ZX Interface1 is connected and activated.
;
;	$Id: if1_installed.asm,v 1.1 2006-06-28 22:21:26 stefano Exp $
;

	XLIB	if1_installed
	
if1_installed:
	ld	hl,(23635)
	ld	de,23755
	sbc	hl,de
	ld	hl,0
	ret	z
	inc	hl
	ret
