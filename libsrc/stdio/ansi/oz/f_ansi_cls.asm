;
; 	ANSI Video handling for Sharp OZ family
;
; 	CLS - Clear the text screen
;
;
;	Stefano Bodrato - Aug. 2002
;
;
;	$Id: f_ansi_cls.asm,v 1.2 2003-05-21 12:53:23 stefano Exp $
;

	XLIB	ansi_cls
	XREF	base_graphics

	LIB     swapgfxbk
        XREF	swapgfxbk1

.ansi_cls


	call	swapgfxbk

        ld      hl,(base_graphics)
        ld	d,h
        ld	e,l
	inc	de
        ld      bc,2400-1
        ldir

	jp	swapgfxbk1
