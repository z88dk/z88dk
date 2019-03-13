;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
;	Stefano Bodrato - 2014
;
;	Get a sector.
;	A standard 178K Opus disk has 0..718 sectors
;	Each sector is 256 bytes long
;
;	int __CALLEE__ opus_getsect_callee(int drive, int sector, char * buffer); 
;
;	$Id: opus_getsect_callee.asm,v 1.5 2016-07-14 17:44:17 pauloscustodio Exp $
;

SECTION code_clib
PUBLIC	opus_getsect_callee
PUBLIC	_opus_getsect_callee
;PUBLIC	ASMDISP_OPUS_GETSECT_CALLEE

PUBLIC	opus_getsect_asmentry

	EXTERN	opus_rommap
	EXTERN	P_DEVICE

opus_getsect_callee:
_opus_getsect_callee:

	pop	af
	pop	de		; buffer location
	pop	hl		; sector number
	pop bc		; c=drive#
	push af

opus_getsect_asmentry:


	call	opus_rommap
;	call	$1708		; Page in the Discovery ROM
	ld	a,c		; drive #

	ld	bc,$0200		; load sector
	call P_DEVICE

	call	$1748		; Page out the Discovery ROM
	ld		hl,0
	ret

;DEFC ASMDISP_OPUS_GETSECT_CALLEE = # opus_getsect_asmentry - opus_getsect_callee
