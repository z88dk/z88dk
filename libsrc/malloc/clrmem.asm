;
;        Small C+ Library
; 
;       More Memory Functions
; 
;       Added to Small C+ 12/3/99 djm
; 
;       This one is writ by me!
; 
; 
;       void clrmem(void *addr, int size)
; 
;       Allocate memory for numsize and clear it (set to 0)
;


                XLIB    clrmem


.clrmem
        pop     hl
        pop     bc      ;length
        pop     de      ;buffer
        push    de
        push    bc
        push    hl

        ld      a,b
        or      c
        ret     z       ;so no duff stuff!
        ld      l,e
        ld      h,d
        inc     de
        ld      (hl),0
        dec     bc
        ld      a,b
        or      c
        ret     z
        ldir            ;quick'n'easy
        ret
        