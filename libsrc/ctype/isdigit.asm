;
; Small C z88 Character functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
; 22 August 1998
;
; 17/2/99 djm rewritten to be shorter

                XLIB    isdigit


;isdigit (c) char c
;return address, c

.isdigit
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
	ld	hl,0
        cp      '0'
	ret	c
        cp      '9'+1
	ret	nc
	inc	hl
        ret
