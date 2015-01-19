;	Sprinter fcntl library
;
;	$Id: fdtell.asm,v 1.2 2015-01-19 01:32:43 pauloscustodio Exp $
;


                PUBLIC    fdtell

;int fdtell(int fd)
;
;Dumps in dump the file position, and returns 0 if all went well


.fdtell
	pop	bc
	pop	hl	;fd
	push	hl
	push	bc
	ld	a,l
	ld	hl,0
	ld	ix,0
	ld	b,1	;from current position
	ld	c,$15	;MOVE_FP
	rst	$10
	push	ix
	pop	de
	ret	nc	;was ok
	ld	hl,-1
	ld	de,-1
	ret

