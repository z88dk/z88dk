;       Z88 Small C+ Run Time Library 
;
;       Get Long Pointer from Near Memory

                XLIB    l_getptr


;Fetch long from (hl)

.l_getptr
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        inc     hl
        ld      c,(hl)
        ex      de,hl   ;low byte
        ld      e,c
        ld      d,0
        ret

