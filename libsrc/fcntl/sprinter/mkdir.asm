;	Sprinter fcntl library
;
;	$Id: mkdir.asm,v 1.3 2016-03-13 18:14:13 dom Exp $
;

                SECTION   code_clib
                PUBLIC   mkdir

;int mkdir(char *path, mode_t mode)


.mkdir	
	pop	bc
	pop	de
	pop	hl
	push	hl
	push	de
	push	bc
	push	ix	;save callers
	ld	c,$1B	;MKDIR
	rst	$10
	pop	ix	;get it back
	ld	hl,0
	ret	nc
	dec	hl	;-1
	ret

