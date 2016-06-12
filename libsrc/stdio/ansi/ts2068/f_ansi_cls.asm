;
;       Spectrum C Library
;
; 	ANSI Video handling for ZX Spectrum
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: f_ansi_cls.asm,v 1.4 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_cls

.ansi_cls
		
	in	a,(255)
	and	@11111000
	or	@00000110
	out     (255),a

	ld      hl,16384
	ld      de,16385
	ld      (hl),0
	ld      bc,6143
	ldir
	ld	hl,24576
	ld	de,24577
	ld	(hl),0
	ld	bc,6143
	ldir
	ret
	
