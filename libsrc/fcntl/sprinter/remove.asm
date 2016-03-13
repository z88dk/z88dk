;       Sprinter fcntl library
;
;	$Id: remove.asm,v 1.4 2016-03-13 18:14:13 dom Exp $
;

                SECTION   code_clib
                PUBLIC    remove

;int remove(char *name)

.remove
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

