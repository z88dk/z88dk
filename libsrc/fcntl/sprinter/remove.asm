;       Sprinter fcntl library
;
;	$Id: remove.asm,v 1.3 2015-01-19 01:32:43 pauloscustodio Exp $
;

                PUBLIC    remove

;int remove(char *name)

.remove
        pop     de
        pop     hl      ;dest filename
        push    hl
        push    de
	ld	c,$0E	;DELETE
	rst	$10
        ld      hl,0
        ret     nc
        dec     hl      ;=1
        ret

