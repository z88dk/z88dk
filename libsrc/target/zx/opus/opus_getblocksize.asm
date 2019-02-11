;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
;	Stefano Bodrato - Jun. 2006
;
;	int opus_getblocksize (int drive);
;	
;	$Id: opus_getblocksize.asm,v 1.5 2016-06-27 19:16:34 dom Exp $
;


		SECTION code_clib
		PUBLIC 	opus_getblocksize
		PUBLIC 	_opus_getblocksize

		EXTERN	opus_rommap

		EXTERN	P_DEVICE
		

opus_getblocksize:
_opus_getblocksize:
		push	ix		;save callers
		
		ld	ix,4
		add	ix,sp

		ld	hl,-1

		ld	a,(ix+0)	; drive
		and	a		; drive no. = 0 ?
		jr	z,getblocksize_exit		; yes, return -1
		dec	a
		cp	5		; drive no. >5 ?
		jr	nc,getblocksize_exit		; yes, return -1

		call	opus_rommap
		;call	$1708		; Page in the Discovery ROM
		ld	a,(ix+0)	; drive
		ld	bc,$0400	; inquire disk
		call	P_DEVICE
		call	$1748		; Page out the Discovery ROM

		ld	h,b		; block size
		ld	l,c
.getblocksize_exit
		pop	ix		; restore callers
		ret
		
