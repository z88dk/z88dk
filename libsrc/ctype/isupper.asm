;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	17/2/99 djm - rewritten to remove jp - shorter
;
;	$Id: isupper.asm,v 1.2 2001-04-17 08:05:14 stefano Exp $
;

                XLIB    isupper


;isupper (c) char c
;return address, c

.isupper
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
	ld	hl,0
        cp      'A'	;fail
	ret	c
        cp      'Z'+1
	ret	nc
	inc	hl	;success
        ret
