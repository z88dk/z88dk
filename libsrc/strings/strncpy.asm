;
; Small C z88 String functions
;
; Copy s2 to s1, truncating or null-padding to always copy n bytes
; Return s1
;
; djm 15/12/99 Fixed so return s1

                XLIB    strncpy

;strncpy(s1,s2,n) char *s1, *s2, int n
;Stack on entry runs..
;return address,n, s2, s1


.strncpy
        ld      hl,2   
        add     hl,sp
        ld      c,(hl)
        inc     hl
        ld      b,(hl)  ;bc=n
        ld      a,c
        or      b
        ret     z       ;check c<>0
        inc     hl
        ld      e,(hl)  
        inc     hl
        ld      d,(hl)  ;de=s2
        inc     hl
        ld      a,(hl)
        inc     hl
        ld      h,(hl)  
        ld      l,a     ;hl=s1
.strncpy1
        ld      a,(de)
        ld      (hl),a
        and     a
        jp      z,strncpy2
        inc     hl
        inc     de
        dec     bc
        ld      a,b
        or      c
        jp      nz,strncpy1
.strncpy3
        ld      hl,6
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
	ex	de,hl
        ret
;Here, we have to pad out..
.strncpy2
        ld      (hl),0
        inc     hl
        dec     bc
        ld      a,b
        or      c
        jp      nz,strncpy2
        jp      strncpy3
