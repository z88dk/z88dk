;	Sprinter fcntl library
;
;	$Id: rmdir.asm,v 1.1 2002-11-20 20:28:44 dom Exp $
;


                XLIB   rmdir

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

