;
; $Id: fdgetpos.asm,v 1.2 2015-01-19 01:32:43 pauloscustodio Exp $

	PUBLIC	fdgetpos

.fdgetpos
	ld	hl,1	;non zero is error
	ret
