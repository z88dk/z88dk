; Internal routine to read increment local address HL with far pointer EBC
; 31/3/00 GWL

; Corrupts D via __far_page, but preserves A

;
; $Id: __far_incptr.asm,v 1.4 2016-06-10 22:42:22 dom Exp $
;

        SECTION code_clib
        PUBLIC    __far_incptr

        EXTERN     __far_page


.__far_incptr
        inc     hl
        inc     c
        ret     nz
        inc     b
        jr      nz,skiphigh
        inc     e
.skiphigh
        push    af
        call    __far_page
        pop     af
        ret

