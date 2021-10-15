
SECTION code_clib
SECTION code_l_sccz80

PUBLIC      dload
EXTERN      fa

;----------------
; Load FA from hl
;----------------
dload:
    ld      de,fa
    ld      b,6
loop:
    ld      a,(hl)
    ld      (de),a
    inc     de
    inc     hl
    dec     b
    jp      NZ,loop

    ret

