;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
;	Stefano Bodrato - Jun. 2006
;
;	unsigned char opus_lptread;
;	
;	$Id: opus_lptread.asm,v 1.1 2007-10-04 12:18:56 stefano Exp $
;


		XLIB 	opus_lptread

		LIB	opus_rommap

		XREF	P_DEVICE
		

opus_lptread:
		
		call	opus_rommap

		call	$1708		; Page in the Discovery ROM
		ld	b,2
		ld	a,$81
		call	P_DEVICE
		call	$1748		; Page out the Discovery ROM
					; HL = number of blocks
		ret
