;
; Small C z88 String functions
;
; Concatenate s2 on the end of s1. Space for s1 must be large enough...


                XLIB    strcat

;strcat(s1,s2) char *s1, *s2
;Stack on entry runs..
;return address, s2, s1


.strcat
        ld      hl,4	;s1
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        ld      c,e             ;keep this for later
        ld      b,d
;Find end of s1
.strcat1
        ld      a,(de)
        inc     de
        and     a
        jp      nz,strcat1
        dec     de      ;points to null at end of string
;Find s2..
        ld      hl,2	;s2
        add     hl,sp
        ld      a,(hl)
        inc     hl
        ld      h,(hl) 
        ld      l,a     ;hl=s2, de=end of s1
.strcat2
        ld      a,(hl)
        ld      (de),a
        inc     de
        inc     hl
        and     a
        jp      nz,strcat2
;Now, bc still holds pointer to s1, so plop it into hl and outta here!
        ld      h,b
        ld      l,c
        ret





