;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
;	Stefano Bodrato - Jun. 2006
;
;	unsigned char opus_lptread;
;	
;	$Id: opus_lptread.asm,v 1.2 2014-11-21 15:17:38 stefano Exp $
;


		XLIB 	opus_lptread

		LIB	opus_rommap

		XREF	P_DEVICE
		

opus_lptread:
		
		call	opus_rommap
		;call	$1708		; Page in the Discovery ROM
		ld	b,2
		ld	a,$81
		call	P_DEVICE
		jp	$1748		; Page out the Discovery ROM
					; HL = number of blocks
		;ret
