;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
;	Stefano Bodrato - Jun. 2006
;
;	void opus_lptwrite (unsigned char databyte);
;	
;	$Id: opus_lptwrite.asm,v 1.1 2007-10-04 12:18:56 stefano Exp $
;


		XLIB 	opus_lptwrite

		LIB	opus_rommap

		XREF	P_DEVICE
		

opus_lptwrite:
		
		call	opus_rommap

		ld	ix,2
		add	ix,sp

		call	$1708		; Page in the Discovery ROM
		ld	h,(ix+0)	; drive
		ld	b,2
		ld	a,$81
		call	P_DEVICE
		call	$1748		; Page out the Discovery ROM
					; HL = number of blocks
		ret
