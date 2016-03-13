;	Sprinter fcntl library
;
;	$Id: rmdir.asm,v 1.3 2016-03-13 18:14:13 dom Exp $
;


                SECTION   code_clib
                PUBLIC   rmdir

;int rmdir(char *path, mode_t mode)


.rmdir	
	pop	bc
	pop	de
	pop	hl
	push	hl
	push	de
	push	bc
	push	ix
	ld	c,$1C	;RMDIR
	rst	$10
	ld	hl,0
	pop	ix
	ret	nc
	dec	hl	;-1
	ret

