; Internal routine to read increment local address HL with far pointer EBC
; 31/3/00 GWL

; Corrupts D via farseg1, but preserves A

;
; $Id: incfar.asm,v 1.4 2016-06-10 22:42:22 dom Exp $
;

        SECTION code_clib
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

