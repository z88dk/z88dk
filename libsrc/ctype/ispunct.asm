;
; Small C z88 Character functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
;
; 1/3/99 djm
;
; Hurrah, this is our first table for our isxxx routines!

                XLIB    ispunct


;ispunct (c) char c
;return address, c

.ispunct
        ld      hl,2
        add     hl,sp
        ld      b,(hl)
        ld      de,ispunct_tab
        ld      hl,1    ;mark success
.ispunct1
        ld      a,(de)
        and     a
        jr      nz,ispunct2
        dec     hl      ;fail!
        ret
.ispunct2
        cp      b
        inc     de
        ret     z
        jr      ispunct1

; Hopefully these codes translate over okay

.ispunct_tab
        defm    "!$%^&*()_+={[]}#~'@;:/?.>,<\|"
; This line contains the " and the pound sign
        defb    34,163,0

