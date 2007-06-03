;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 19/05/2007
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; get a char from stream
;     
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; int nb_getc( int stream );
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: nb_getc.asm,v 1.1 2007-06-03 15:13:06 stefano Exp $
;


	XLIB nb_getc
	
	LIB ZCALL

.nb_getc
	; __FASTCALL__ mode, stream number is stored in HL
	ld	e,l
	
	call	ZCALL
	defb	$31	; zinput

	ld	hl,-1
	ret	c
	
	inc	hl
	ld	l,a
	ret
