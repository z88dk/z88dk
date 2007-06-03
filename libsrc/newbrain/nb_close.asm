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
; $Id: nb_close.asm,v 1.1 2007-06-03 15:13:06 stefano Exp $
;


	XLIB nb_close

	LIB ZCALL
	
.nb_close
	; __FASTCALL__ mode, stream number is stored in HL
	ld	e,l
	call	ZCALL
	defb	$34	; ZCLOSE
	ret
