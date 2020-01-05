                SECTION code_clib

	PUBLIC	fdgetpos
	PUBLIC	_fdgetpos

.fdgetpos
._fdgetpos
	ld	hl,1	;non zero is error
	ret
