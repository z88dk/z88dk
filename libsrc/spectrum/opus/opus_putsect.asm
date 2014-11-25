;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
;	Stefano Bodrato - 2014
;
;	Write a sector.
;	A standard 178K Opus disk has 0..718 sectors
;	Each sector is 256 bytes long
;
;	int opus_putsect(int drive, int sector, char * buffer); 
;
;	$Id: opus_putsect.asm,v 1.2 2014-11-25 17:09:23 stefano Exp $
;

XLIB opus_putsect
;XREF ASMDISP_OPUS_PUTSECT_CALLEE
LIB opus_putsect_callee
LIB opus_putsect_asmentry

.opus_putsect

	pop af
	pop de		; buffer location
	pop hl		; sector number
	pop bc		; c=drive#
	push bc		; c=drive#
	push hl		; sector number
	push de		; buffer location
	push af
	
	jp	opus_putsect_asmentry
;   jp ASMDISP_OPUS_PUTSECT_CALLEE + opus_putsect_callee
