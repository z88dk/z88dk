;
; Small C z88 String functions
;
; Copy string s2 to s1, s1 must be big enough, return s1
;
; 1/3/99 djm - fixed bug in return value


                XLIB    strcpy

;strcpy(s1,s2) char *s1, *s2
;Stack on entry runs..
;return address, s2, s1


.strcpy
        ld      hl,2
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)  ;de=s2
        inc     hl
        ld      a,(hl)
        inc     hl
        ld      h,(hl)  
        ld      l,a     ;hl=s1
        ld      c,l
        ld      b,h     ;keep s1 safe
.strcpy1
        ld      a,(de)
        ld      (hl),a
        inc     hl
        inc     de
        and     a
        jp      nz,strcpy1
        ld      l,c
        ld      h,b     ;restore s1
        ret


