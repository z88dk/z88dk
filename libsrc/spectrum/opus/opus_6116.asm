;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
;	Stefano Bodrato - Jun. 2006
;
; 	This routine checks if the 6116 memory expansion is present.
;
;	$Id: opus_6116.asm,v 1.5 2016-06-27 19:16:34 dom Exp $
;

		SECTION code_clib
		PUBLIC	opus_6116
		PUBLIC	_opus_6116
	
		EXTERN	opus_rommap

.opus_6116
._opus_6116
		call	opus_rommap
		;call	$1708		; Page in the Discovery ROM

		ld	hl,3001
		ld	a,(hl)
		ld	(hl),255
		bit	1,(hl)
		ld	(hl),a

		ld	hl,0
		jr	z,noram
		inc	hl
.noram
		jp	$1748		; Page out the Discovery ROM
		;ret
	
