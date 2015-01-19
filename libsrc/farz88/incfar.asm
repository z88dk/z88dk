; Internal routine to read increment local address HL with far pointer EBC
; 31/3/00 GWL

; Corrupts D via farseg1, but preserves A

;
; $Id: incfar.asm,v 1.3 2015-01-19 01:32:43 pauloscustodio Exp $
;


        PUBLIC    incfar

        EXTERN     farseg1


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

