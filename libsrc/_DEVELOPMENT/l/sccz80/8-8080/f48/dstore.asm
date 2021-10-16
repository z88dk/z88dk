
SECTION code_clib
SECTION code_l_sccz80

PUBLIC      dstore
EXTERN      fa

;--------------
; Copy FA to hl
;--------------
dstore:
    ld      de,fa
    ld      c,a
    ld      b,6
loop:
    ld      a,(de)
    ld      (hl),a
    inc     de
    inc     hl
    dec     b
    jp      NZ,loop
    ld      a,c
    ret                 ; returns de=fa+6, hl=hl+6
