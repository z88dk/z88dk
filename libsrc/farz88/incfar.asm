; Internal routine to read increment local address HL with far pointer EBC
; 31/3/00 GWL

; Corrupts D via farseg1, but preserves A


        XLIB    incfar

        LIB     farseg1


.incfar
        inc     hl
        inc     c
        ret     nz
        inc     b
        jr      nz,skiphigh
        inc     e
.skiphigh
        push    af
        call    farseg1
        pop     af
        ret

