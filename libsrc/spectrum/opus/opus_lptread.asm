;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
;	Stefano Bodrato - Jun. 2006
;
;	unsigned char opus_lptread;
;	
;	$Id: opus_lptread.asm,v 1.4 2015-01-19 01:33:10 pauloscustodio Exp $
;


		PUBLIC 	opus_lptread

		EXTERN	opus_rommap

		EXTERN	P_DEVICE
		

opus_lptread:
		
		call	opus_rommap
		;call	$1708		; Page in the Discovery ROM
		ld	b,2
		ld	a,$81
		call	P_DEVICE
		jp	$1748		; Page out the Discovery ROM
					; HL = number of blocks
		;ret
