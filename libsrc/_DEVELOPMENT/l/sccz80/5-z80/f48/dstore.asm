
SECTION code_clib
SECTION code_l_sccz80

PUBLIC  dstore
EXTERN  fa

;--------------
; Copy FA to hl
;--------------
dstore:
    ld      de,fa
    ex      de,hl
    ld      bc,6
    ldir
    ex      de,hl    ; returns de=fa+6, hl=hl+6
    ret
