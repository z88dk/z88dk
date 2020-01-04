;
; $Id: fdgetpos.asm,v 1.4 2016-03-06 21:39:54 dom Exp $

                SECTION code_clib

	PUBLIC	fdgetpos
	PUBLIC	_fdgetpos

.fdgetpos
._fdgetpos
	ld	hl,1	;non zero is error
	ret
