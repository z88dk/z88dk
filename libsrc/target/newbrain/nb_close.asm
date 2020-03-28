;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 19/05/2007
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; closes a stream
;     
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; void nb_close( int stream );
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: nb_close.asm,v 1.3 2016-06-19 20:33:40 dom Exp $
;

        SECTION code_clib
	PUBLIC nb_close
	PUBLIC _nb_close

	EXTERN ZCALL
	
.nb_close
._nb_close
	; __FASTCALL__ mode, stream number is stored in HL
	ld	e,l
	call	ZCALL
	defb	$34	; ZCLOSE
	ret
