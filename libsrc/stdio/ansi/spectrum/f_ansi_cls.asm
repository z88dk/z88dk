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
;	$Id: f_ansi_cls.asm,v 1.5 2016-04-04 18:31:23 dom Exp $
;

	SECTION	code_clib
	PUBLIC	ansi_cls

.ansi_cls
        ld      hl,16384
        ld      de,16385
        ld      (hl),0
        ld      bc,6143
        ldir
        ; clear attributes
        ld      a,(23693)
        ld      hl,22528
        ld      (hl),a
        ld      de,22529
        ld      bc,767
        ldir
	ret
	
