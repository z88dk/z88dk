
SECTION code_clib
SECTION code_l_sccz80

PUBLIC    dstore
EXTERN  fa


;--------------
; Copy FA to hl
;--------------
dstore:
    ld      b,6
dstore_1:
    ld      a,(de)
    ld      (hl+),a
    inc     de
    dec     b
    jr      NZ,dstore_1
    ret                     ; returns de=fa+6, hl=hl+6
