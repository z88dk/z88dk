;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	17/2/99 djm
;
;	$Id: isalpha.asm,v 1.2 2001-04-17 08:05:14 stefano Exp $
;

                XLIB    isalpha


;isalpha (c) char c
;return address, c

.isalpha
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
	ld	hl,0	;fail
        cp      'A'
	ret	c
        cp      'z'+1
	ret	nc
        and     223
        cp      'A'
	ret	c
        cp      'Z'+1
	ret	nc
	inc	hl	;success
        ret
