;
; 	ANSI Video handling for the Robotron Z1013
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - Aug 2016
;
;
;	$Id: f_ansi_cls.asm,v 1.1 2016-08-05 07:04:10 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_cls

.ansi_cls
	ld	hl,$EC00
	ld	(hl),32 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,32*32
	ldir
	ret
