;	Sprinter fcntl library
;
;	$Id: rename.asm,v 1.4 2016-03-13 18:14:13 dom Exp $
;


                SECTION   code_clib
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
	push	ix
	ld	c,$10	;REANAME
	rst	$10
	ld	hl,0
	pop	ix
	ret	nc
	dec	hl
	ret
