;
;       Small C+ Library
;
;       ctype/toascii(char c)
;       returns c&127
;
;       djm 1/3/99
;

                XLIB    toascii


;toascii (c) char c
;return address, c

.toascii
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
        and     127
        ld      l,a
        ld      h,0
        ret

