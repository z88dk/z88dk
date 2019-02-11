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
;	$Id: opus_putsect.asm,v 1.5 2016-07-14 17:44:17 pauloscustodio Exp $
;

SECTION code_clib
PUBLIC opus_putsect
PUBLIC _opus_putsect
;EXTERN ASMDISP_OPUS_PUTSECT_CALLEE
EXTERN opus_putsect_callee
EXTERN opus_putsect_asmentry

.opus_putsect
._opus_putsect

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
