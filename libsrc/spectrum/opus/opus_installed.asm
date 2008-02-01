;
;	ZX Spectrum specific routines
;
;	int opus_installed();
;
;	The result is:
;	- 0 (false) if the ZX Interface1 is missing
;	- 1 (true) if the ZX Interface1 is connected
;
;	This function has the side of loading the Interface 1
;	system variables if they aren't already present.
;
;	Shouldn't conflict with other interfaces.
;
;	$Id: opus_installed.asm,v 1.1 2008-02-01 10:36:40 stefano Exp $
;

	XLIB	opus_installed
	
opus_installed:

	ld	hl,($5c4f)
	and	a
	ld	de,$5cb6
	sbc	hl,de
	ld	hl,0
	ret	nz
	inc	hl
	ret
