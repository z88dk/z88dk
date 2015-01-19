;	Sprinter fcntl library
;
;	$Id: mkdir.asm,v 1.2 2015-01-19 01:32:43 pauloscustodio Exp $
;


                PUBLIC   mkdir

;int mkdir(char *path, mode_t mode)


.mkdir	
	pop	bc
	pop	de
	pop	hl
	push	hl
	push	de
	push	bc
	ld	c,$1B	;MKDIR
	rst	$10
	ld	hl,0
	ret	nc
	dec	hl	;-1
	ret

