;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;
;	1/3/99 djm
;
;	Stylish, this returned the wrong way! (djm 17/5/99)
;
;	$Id: iscntrl.asm,v 1.2 2001-04-17 08:05:14 stefano Exp $
;

                XLIB    iscntrl


;iscntrl (c) char c
;return address, c

.iscntrl
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
        ld      hl,0
        cp      32
        ret     nc      ; > 32
	inc	hl	;success
        ret

