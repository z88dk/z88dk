;
; $Id: fdgetpos.asm,v 1.1 2001-05-01 13:55:21 dom Exp $

	XLIB	fdgetpos

.fdgetpos
	ld	hl,1	;non zero is error
	ret
