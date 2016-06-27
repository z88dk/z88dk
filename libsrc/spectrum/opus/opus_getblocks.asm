;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
;	Stefano Bodrato - Jun. 2006
;
;	int opus_getblocks (int drive);
;	
;	$Id: opus_getblocks.asm,v 1.4 2016-06-27 19:16:34 dom Exp $
;

		SECTION code_clib
		PUBLIC 	opus_getblocks
		PUBLIC 	_opus_getblocks

		EXTERN	opus_rommap

		EXTERN	P_DEVICE
		

opus_getblocks:
_opus_getblocks:
		push	ix		;save callers		
		ld	ix,4
		add	ix,sp

		ld	hl,-1

		ld	a,(ix+0)	; drive
		and	a		; drive no. = 0 ?
		jr	z,getblocks_exit		; yes, return -1
		dec	a
		cp	5		; drive no. >5 ?
		jr	nc,getblocks_exit		; yes, return -1

		;call	$1708		; Page in the Discovery ROM
		call	opus_rommap
		ld	a,(ix+0)	; drive
		ld	bc,$0400	; inquire disk
		call	P_DEVICE
		call	$1748		; Page out the Discovery ROM
					; HL = number of blocks
.getblocks_exit
		pop	ix		; restore callers
		ret
