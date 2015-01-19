;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 19/05/2007
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; close all the streams
;     
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; void nb_clear( );
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: nb_clear.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;


	PUBLIC nb_clear

	EXTERN nb_close
	
.nb_clear
	ld	a,0
.closelp
	ld	h,0
	ld	l,a
	push	af
	call	nb_close
	pop	af
	inc	a
	and	a
	jr	nz,closelp
	ret
