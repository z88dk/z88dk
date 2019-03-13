;
;	ZX Spectrum specific routines
;
;	int trdos_installed();
;
;	The result is:
;	- 0 (false) if the TRDOS system variables are not installed
;	- 1 (true) if the Betadisk interface is connected and activated.
;
;	$Id:
;

	SECTION code_clib
	PUBLIC	trdos_installed
	PUBLIC	_trdos_installed
	
trdos_installed:
_trdos_installed:
	ld	hl,(23635)
	ld	de,23867
	sbc	hl,de
	ld	a,h
	or	l
	ld	hl,0
	ret	nz
	inc	hl
	ret
