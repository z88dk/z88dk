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
;	$Id: f_ansi_cls.asm,v 1.1 2010-11-26 11:37:32 stefano Exp $
;

	XLIB	ansi_cls

.ansi_cls
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
	
