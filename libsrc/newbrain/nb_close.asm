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
; $Id: nb_close.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;


	PUBLIC nb_close

	EXTERN ZCALL
	
.nb_close
	; __FASTCALL__ mode, stream number is stored in HL
	ld	e,l
	call	ZCALL
	defb	$34	; ZCLOSE
	ret
