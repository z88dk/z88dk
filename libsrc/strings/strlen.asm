;* Strlen for Small C z88
;* Written by D Morris <djm@jb.man.ac.uk>
;* Assembler is great, nice and quick!

                XLIB strlen


;strlen(s) char *s

.strlen
        ld      hl,2
        add     hl,sp  
        ld      e,(hl)
        inc     hl
        ld      d,(hl)  ;hl = *s
        ld      hl,0    ; our counter
.strlen1
        ld      a,(de)
        and     a
        ret     z
        inc     de
        inc     hl
        jr      strlen1

