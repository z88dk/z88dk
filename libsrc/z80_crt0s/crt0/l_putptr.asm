;       Z88 Small C+ Run Time Library 
;       Long functions
;

                PUBLIC    l_putptr


.l_putptr
        ld      a,l
        ld      (bc),a
        inc     bc
        ld      a,h
        ld      (bc),a
        inc     bc
        ld      a,e
        ld      (bc),a
        ret

