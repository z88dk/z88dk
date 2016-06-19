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
; $Id: nb_clear.asm,v 1.3 2016-06-19 20:33:40 dom Exp $
;

        SECTION code_clib
	PUBLIC nb_clear
	PUBLIC _nb_clear

	EXTERN nb_close
	
.nb_clear
._nb_clear
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
