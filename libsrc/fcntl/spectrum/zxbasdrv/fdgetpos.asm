;
; fdgetpos:  forget it !
;
; Stefano - 5/7/2006
;
;
; $Id: fdgetpos.asm,v 1.3 2016-06-23 20:40:25 dom Exp $

	SECTION code_clib
	PUBLIC	fdgetpos
	PUBLIC	_fdgetpos

.fdgetpos
._fdgetpos
	ld	hl,-1
	ret
