;       Z88 Small C+ Run Time Library 
;       Long functions
;

                XLIB    l_glong


;Fetch long from (hl)

.l_glong
        ld      c,(hl)
        inc     hl
        ld      b,(hl)
        inc     hl
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        ld      h,b
        ld      l,c
        ret

