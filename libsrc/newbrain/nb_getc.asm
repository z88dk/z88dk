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
; $Id: nb_getc.asm,v 1.3 2016-06-19 20:33:40 dom Exp $
;

        SECTION code_clib
	PUBLIC nb_getc
	PUBLIC _nb_getc
	
	EXTERN ZCALL

.nb_getc
._nb_getc
	; __FASTCALL__ mode, stream number is stored in HL
	ld	e,l
	
	call	ZCALL
	defb	$31	; zinput

	ld	hl,-1
	ret	c
	
	inc	hl
	ld	l,a
	ret
