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
;	$Id: opus_getsect_callee.asm,v 1.1 2014-11-21 15:17:38 stefano Exp $
;


XLIB	opus_getsect_callee
PUBLIC	opus_getsect_asmentry

	LIB	opus_rommap
	XREF	P_DEVICE

opus_getsect_callee:

	pop	af
	pop	de		; buffer location
	pop	hl		; sector number
	pop bc		; c=drive#
	push af


opus_getsect_asmentry:

	ld	a,c		; drive #

	call	opus_rommap
;	call	$1708		; Page in the Discovery ROM

	ld	b,2		; load sector
	ld	c,0
	call P_DEVICE

	call	$1748		; Page out the Discovery ROM
	ld		hl,0
	ret

