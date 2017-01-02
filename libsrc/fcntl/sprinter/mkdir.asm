;	Sprinter fcntl library
;
;	$Id: mkdir.asm,v 1.4 2017-01-02 21:02:22 aralbrec Exp $
;

                SECTION   code_clib
                PUBLIC   mkdir
                PUBLIC   _mkdir

;int mkdir(char *path, mode_t mode)


.mkdir	
._mkdir
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

