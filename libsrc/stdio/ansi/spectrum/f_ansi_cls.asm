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
;	$Id: f_ansi_cls.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;

	XLIB	ansi_cls

.ansi_cls
        ld      hl,16384
        ld      de,16385
        ld      (hl),0
        ld      bc,6143
        ldir
        ; clear attributes
        ld      a,7
        ld      (23693),a
        ld      (23624),a
        ld      hl,22528
        ld      (hl),a
        ld      de,22529
        ld      bc,767
        ldir
	ret
	