;
; Small C z88 String functions
;
; Compare strings:  s1>s2: >0 s1==s2: 0 s1<s2: <0
;
; Fixed djm 25/4/99 Previously would return non zero if the two
; strings matched (it ignored the \0 at the end!)

                XLIB    strcmp

;strncmp(s1,s2) char *s1, *s2
;Stack on entry runs..
;return address, s2, s1


.strcmp
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
.strcmp1
        ld      a,(de)
        and     a
        jr      z,strcmp2
        cp      (hl)
        jr      nz,strcmp2
        inc     hl
        inc     de
        jp      strcmp1
.strcmp2
        ld      a,(hl)
        and     a
        jp      nz,strcmp3
;End of s1, return hl=0
        ld      l,a
        ld      h,a
        ret
;Okay, take the defn to assume if the value at *s1 and value and *s2
;This is horrible, and probably returns the incorrect result...but WTF?
.strcmp3
        ex      de,hl
        ld      a,(de)  ;s1
        sub     (hl)
        ld      l,a
        ld      h,0
        ret     nc
        ld      h,255
        ret
