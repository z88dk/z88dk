;       Z88 Small C+ Run Time Library 
;       Long functions
;

                XLIB    l_glong


;Fetch long from (hl)

.l_glong
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        inc     hl
        ld      c,(hl)
        inc     hl
        ld      b,(hl)
        ex      de,hl
        ld      d,b
        ld      e,c
        ret

