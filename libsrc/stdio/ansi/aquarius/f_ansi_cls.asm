;
; 	ANSI Video handling for the Mattel Aquarius
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - Dec. 2001
;
;
;	$Id: f_ansi_cls.asm,v 1.3 2016-04-04 18:31:22 dom Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_cls
	EXTERN	aquarius_attr

.ansi_cls
	ld	hl,$3000
	ld	(hl),32 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,999
	ldir
	
	ld	hl,$3400
	;ld	a,(aquarius_attr)
	ld	a,$70
	ld	(hl),a
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,999
	ldir
	
	ret

