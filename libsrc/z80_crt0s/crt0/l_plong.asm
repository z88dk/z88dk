;       Z88 Small C+ Run Time Library 
;       Long functions
;

                PUBLIC    l_plong


.l_plong
        ld      a,l
        ld      (bc),a
        inc     bc
        ld      a,h
        ld      (bc),a
        inc     bc
        ld      a,e
        ld      (bc),a
        inc     bc
        ld      a,d
        ld      (bc),a
        ret

