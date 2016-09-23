;
; 	ANSI Video handling for the Robotron Z9001
;
;	Stefano Bodrato - Sept. 2016
;
;
; 	CLS - Clear the screen
;	
;
;
;	$Id: f_ansi_cls.asm,v 1.1 2016-09-23 06:21:35 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_cls

.ansi_cls
	ld	hl,$EC00
	ld	(hl),32 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,40*24
	ldir
	ret
