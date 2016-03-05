;
; $Id: fdgetpos.asm,v 1.3 2016-03-05 00:13:02 dom Exp $

	PUBLIC	fdgetpos
	PUBLIC	_fdgetpos

.fdgetpos
._fdgetpos
	ld	hl,1	;non zero is error
	ret
