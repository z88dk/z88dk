;
; Small C z88 String functions
;
; Concatenate s2 on the end of s1. Space for s1 must be large enough...
; At most n characters are moved
;
; $Id: strncat.asm,v 1.2 2001-04-11 12:15:32 dom Exp $


                XLIB    strncat

;strncat(s1,s2,n) char *s1, *s2
;Stack on entry runs..
;return address,n, s2, s1


.strncat
        ld      hl,7    ;we're going down!
        add     hl,sp
        ld      d,(hl)
        dec     hl
        ld      e,(hl)
;Find end of s1
.strncat1
        ld      a,(de)
        inc     de
        and     a
        jp      nz,strncat1
        dec     de      ;points to null at end of string
;Find s2..remember..going down!
        dec     hl
        ld      b,(hl)
        dec     hl
        ld      c,(hl) ;bc=s2
        dec     hl
        ld      a,(hl)
        dec     hl
        ld      l,(hl) 
        ld      h,a     ;hl=n
        or      l
        ret     z       ;hl=0 outta here!

.strncat2
        ld      a,(bc)
        ld      (de),a
        inc     de
        inc     bc
        and     a
        jp      z,strncat3
        dec     hl
        ld      a,h
        or      l
        jp      nz,strncat2
;All finished..now, reclaim value of s1..
;*sob* stack operations..
.strncat3
        ld      hl,6
        add     hl,sp
        ld      a,(hl)
        inc     hl
        ld      h,(hl)
        ld      l,a
        ret





