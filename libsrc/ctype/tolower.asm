;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	$Id: tolower.asm,v 1.2 2001-04-17 08:05:14 stefano Exp $
;

                XLIB    tolower


;tolower (c) char c
;return address, c

.tolower
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
        ld      l,a
        ld      h,0
        cp      'A'
        ret     c
        cp      'Z'+1
        ret     nc
        add     a,32
        ld      l,a
        ret

