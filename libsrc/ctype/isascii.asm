;
;       Small C+ Library
;
;       ctype/isascii(char c)
;
;       djm 1/3/99
;


                XLIB    isascii


;islower (c) char c
;return address, c

.isascii
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
        ld      hl,0    ; failed
        cp      128
        ret     nc
        inc     hl      ; success
        ret
