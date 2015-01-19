;	Sprinter fcntl library
;
;	$Id: rmdir.asm,v 1.2 2015-01-19 01:32:43 pauloscustodio Exp $
;


                PUBLIC   rmdir

;int rmdir(char *path, mode_t mode)


.rmdir	
	pop	bc
	pop	de
	pop	hl
	push	hl
	push	de
	push	bc
	ld	c,$1C	;RMDIR
	rst	$10
	ld	hl,0
	ret	nc
	dec	hl	;-1
	ret

