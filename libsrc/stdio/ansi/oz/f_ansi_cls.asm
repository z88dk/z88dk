;
; 	ANSI Video handling for Sharp OZ family
;
; 	CLS - Clear the text screen
;
;
;	Stefano Bodrato - Aug. 2002
;
;
;	$Id: f_ansi_cls.asm,v 1.5 2016-06-12 16:06:43 dom Exp $
;


        SECTION code_clib
	PUBLIC	ansi_cls
	EXTERN	base_graphics

	EXTERN     swapgfxbk
        EXTERN	swapgfxbk1

.ansi_cls


	call	swapgfxbk

	ld      hl,(base_graphics)
	ld	d,h
	ld	e,l
	inc	de
	ld      bc,2400-1
	xor	a
	ld	(hl),a
	ldir

	jp	swapgfxbk1
