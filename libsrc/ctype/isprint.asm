;
;       Small C+ Library
;
;       ctype/isprint(char c)
;
;       djm 23/12/99
;
;	Okay, printable for the z88 is:
;	7,10,13,32-126,163?
;


                XLIB    isprint


;islower (c) char c
;return address, c

.isprint
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
        ld      hl,1    ; failed
	cp	7
	ret	z
	cp	10
	ret	z
	cp	13
	ret	z
	cp	163
	ret	z
	cp	32
	jr	c,failure
	cp	127
	ret	c
.failure
	dec	hl
	ret
