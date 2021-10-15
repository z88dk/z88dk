
SECTION code_clib
SECTION code_l_sccz80

PUBLIC      dstore
EXTERN      fa

;--------------
; Copy FA to hl
;--------------
dstore:
    ld      de,fa
    ld      b,6
loop:
    ld      a,(de)
    ld      (hl),a
    inc     hl
    inc     de
    dec     b
    jp      NZ,loop

    ret
