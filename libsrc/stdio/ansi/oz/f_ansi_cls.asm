;
; 	ANSI Video handling for Sharp OZ family
;
; 	CLS - Clear the text screen
;	
;	-- ONLY FOO STUFF, FOR NOW !! --
;
;	Stefano Bodrato - Aug. 2002
;
;
;	$Id: f_ansi_cls.asm,v 1.1 2002-11-20 14:15:19 stefano Exp $
;

	XLIB	ansi_cls
	XREF	base_graphics

.ansi_cls

	LIB     swapgfxbk
        XREF	swapgfxbk1

ret
	call	swapgfxbk
	
        ld      hl,(base_graphics)
        ld      (hl),l
        ld      de,0a001h
        ld      bc,2400-1
        ldir

	jp	swapgfxbk1
