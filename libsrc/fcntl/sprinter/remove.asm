;       Sprinter fcntl library
;
;	$Id: remove.asm,v 1.2 2003-09-10 20:22:52 dom Exp $
;

                XLIB    remove

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

