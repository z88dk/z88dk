;	Sprinter fcntl library
;
;	$Id: rename.asm,v 1.2 2003-09-10 20:22:52 dom Exp $
;


                XLIB    rename

;int rename(char *s1,char *s2)
;on stack:
;return address,s2,s1
;s1=orig filename, s2=dest filename

.rename
        pop     bc
        pop     de      ;dest filename
        pop     hl      ;orig filename
        push    hl
        push    de
        push    bc
	ld	c,$10	;REANAME
	rst	$10
	ld	hl,0
	ret	nc
	dec	hl
	ret
