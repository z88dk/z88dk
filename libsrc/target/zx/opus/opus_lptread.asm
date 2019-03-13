;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
;	Stefano Bodrato - Jun. 2006
;
;	unsigned char opus_lptread;
;	
;	$Id: opus_lptread.asm,v 1.5 2016-06-27 19:16:34 dom Exp $
;

		SECTION code_clib
		PUBLIC 	opus_lptread
		PUBLIC _opus_lptread

		EXTERN	opus_rommap

		EXTERN	P_DEVICE
		

opus_lptread:
_opus_lptread:
		
		call	opus_rommap
		;call	$1708		; Page in the Discovery ROM
		ld	b,2
		ld	a,$81
		call	P_DEVICE
		jp	$1748		; Page out the Discovery ROM
					; HL = number of blocks
		;ret
