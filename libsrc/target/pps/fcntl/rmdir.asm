;	Sprinter fcntl library
;
;	$Id: rmdir.asm,v 1.4 2017-01-02 21:02:22 aralbrec Exp $
;


                SECTION   code_clib
                PUBLIC   rmdir
                PUBLIC   _rmdir

;int rmdir(char *path, mode_t mode)


.rmdir	
._rmdir
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

