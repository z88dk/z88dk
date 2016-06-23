; int fdgetpos(int fd, fpos_t *posn)
;returns 0 if OK
;
;	$Id: fdgetpos.asm,v 1.3 2016-06-23 20:31:34 dom Exp $
;

	SECTION code_clib
	PUBLIC	fdgetpos
	PUBLIC	_fdgetpos

.fdgetpos
._fdgetpos
	ret
