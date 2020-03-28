;
;	ZX Spectrum specific routines
;
;	int if1_installed();
;
;	The result is:
;	- 0 (false) if the ZX Interface1 is missing or not paged in
;	- 1 (true) if the ZX Interface1 is connected and activated.
;
;	$Id: if1_installed.asm,v 1.3 2016-06-10 20:02:04 dom Exp $
;

	SECTION code_clib
	PUBLIC	if1_installed
	PUBLIC	_if1_installed
	
if1_installed:
_if1_installed:
	ld	hl,(23635)
	ld	de,23813
	sbc	hl,de
	ld	a,h
	or	l
	ld	hl,0
	ret	nz
	inc	hl
	ret
