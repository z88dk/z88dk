;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 30/05/2007
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
;
; $Id: fdgetpos.asm,v 1.4 2016-06-19 20:26:58 dom Exp $

        SECTION code_clib
	PUBLIC	fdgetpos
	PUBLIC	_fdgetpos

.fdgetpos
._fdgetpos
	ld	hl,-1
	ret
