;       Sprinter fcntl library
;
;	$Id: remove.asm,v 1.5 2017-01-02 21:02:22 aralbrec Exp $
;

                SECTION   code_clib
                PUBLIC    remove
                PUBLIC    _remove

;int remove(char *name)

.remove
._remove
        pop     de
        pop     hl      ;dest filename
        push    hl
        push    de
	push	ix
	ld	c,$0E	;DELETE
	rst	$10
        ld      hl,0
	pop	ix
        ret     nc
        dec     hl      ;=1
        ret

