;	Sprinter fcntl library
;
;	$Id: fdtell.asm,v 1.4 2017-01-02 21:02:22 aralbrec Exp $
;

		SECTION	  code_clib
                PUBLIC    fdtell
                PUBLIC    _fdtell

;int fdtell(int fd)
;
;Dumps in dump the file position, and returns 0 if all went well


.fdtell
._fdtell
	pop	bc
	pop	hl	;fd
	push	hl
	push	bc
	push	ix
	ld	a,l
	ld	hl,0
	ld	ix,0
	ld	b,1	;from current position
	ld	c,$15	;MOVE_FP
	rst	$10
	push	ix
	pop	de
	pop	ix	;get back callers
	ret	nc	;was ok
	ld	hl,-1
	ld	de,-1
	ret

