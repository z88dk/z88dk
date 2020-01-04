;
;       Sprinter C Library
;
; 	ANSI Video handling for Sprinter
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
	ld	d,0		;top left x
	ld	e,0		;top left y
	ld	h,32		;height
	ld	l,80		;depth
	xor	a		;fill character
	ld	b,7		;clear colour?
	ld	c,$57		;CLEAR
	rst	$10
	ret
	
