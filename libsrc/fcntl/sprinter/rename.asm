;	Sprinter fcntl library
;
;	$Id: rename.asm,v 1.3 2015-01-19 01:32:43 pauloscustodio Exp $
;


                PUBLIC    rename

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
