;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
;	Stefano Bodrato - Jun. 2006
;
;	void opus_lptwrite (unsigned char databyte);
;	
;	$Id: opus_lptwrite.asm,v 1.5 2016-06-27 19:16:34 dom Exp $
;

		SECTION code_clib
		PUBLIC 	opus_lptwrite
		PUBLIC 	_opus_lptwrite

		EXTERN	opus_rommap

		EXTERN	P_DEVICE
		

opus_lptwrite:
_opus_lptwrite:
		push	ix		; save callers	
		ld	ix,4
		add	ix,sp

		call	opus_rommap
		;call	$1708		; Page in the Discovery ROM
		ld	h,(ix+0)	; drive
		ld	b,2
		ld	a,$81
		call	P_DEVICE
		call	$1748		; Page out the Discovery ROM
					; HL = number of blocks
		pop	ix		;restore callers
		ret
