;
; int fdgetpos(int fd, long *dump)
;
; Return position in file
;
; This returns longs even though there's no real need to do so
;
; $Id: fdgetpos.asm,v 1.6 2017-01-02 21:02:22 aralbrec Exp $


		SECTION	code_clib
		PUBLIC	fdgetpos
      PUBLIC   _fdgetpos

		INCLUDE "p3dos.def"

		EXTERN	l_plong

		EXTERN	dodos


.fdgetpos
._fdgetpos
	pop	hl	;ret address
	pop	de	;where to store it
	pop	bc	;lower 8 is file handle
	push	bc
	pop	de
	push	hl
	ld	b,c
	push	de	;save store location
	ld	iy,DOS_GET_POSITION
	call	dodos
	pop	bc	;get store location back
	jr	nc,fdgetpos_store
	ld	hl,-1
	ret
.fdgetpos_store
	ld	d,0	;clear upper byte
	call	l_plong
	ld	hl,0
	ret
