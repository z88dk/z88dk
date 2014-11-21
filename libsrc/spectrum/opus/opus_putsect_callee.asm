;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
;	Stefano Bodrato - 2014
;
;	Write a sector.
;	A standard 178K Opus disk has 0..718 sectors
;	Each sector is 256 bytes long
;
;	int __CALLEE__ opus_putsect_callee(int drive, int sector, char * buffer); 
;
;	$Id: opus_putsect_callee.asm,v 1.1 2014-11-21 15:17:38 stefano Exp $
;


XLIB	opus_putsect_callee
PUBLIC	opus_putsect_asmentry

	LIB	opus_rommap
	XREF	P_DEVICE

opus_putsect_callee:

	pop	af
	pop	de		; buffer location
	pop	hl		; sector number
	pop bc		; c=drive#
	push af


opus_putsect_asmentry:

	ld	a,c		; drive #

	call	opus_rommap
;	call	$1708		; Page in the Discovery ROM

	ld	bc,0		; save sector
	call P_DEVICE

	call	$1748		; Page out the Discovery ROM
	ld		hl,0
	ret


