;
; Small C z88 String functions
;
; Reverse a character string


                XLIB    reverse

;reverse(s)     char *s;
;return address, s


.reverse
        ld      hl,2
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        ld      l,e
        ld      h,d
        push    de
        exx
        pop     hl
        ld      bc,0    ;our length counter..
.reverse1
        ld      a,(hl)
        inc     hl
        inc     bc
        and     a
        jp      nz,reverse1
        dec     hl
        dec     hl      ;points to last real character in string..
        ld      a,c
        rrca
        jp      nc,reverse2
;Odd number of characters, so dec our counter
        dec     bc
.reverse2
        dec     bc
        ld      a,b
        or      c
        jp      z,reverse3
        ld      a,(hl)  ;end
        exx
        ld      c,a
        ld      a,(hl)  ;start
        ld      (hl),c
        inc     hl
        exx
        ld      (hl),a
        dec     hl
        jp      reverse2
.reverse3
        ex      de,hl
        ret

