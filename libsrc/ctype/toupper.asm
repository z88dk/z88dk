;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	$Id: toupper.asm,v 1.2 2001-04-17 08:05:14 stefano Exp $
;

                XLIB    toupper


;tolower (c) char c
;return address, c

.toupper
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
        ld      l,a
        ld      h,0
        cp      'a'
        ret     c
        cp      'z'+1
        ret     nc
	and	223
        ld      l,a
        ret

