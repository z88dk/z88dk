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
; $Id: nb_clear.asm,v 1.1 2007-06-03 15:13:06 stefano Exp $
;


	XLIB nb_clear

	LIB nb_close
	
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
