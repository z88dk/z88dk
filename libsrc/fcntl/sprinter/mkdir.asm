;	Sprinter fcntl library
;
;	$Id: mkdir.asm,v 1.1 2002-11-20 20:28:44 dom Exp $
;


                XLIB   mkdir

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

