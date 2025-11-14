
SECTION code_clib
SECTION code_l_sccz80

PUBLIC  dload
EXTERN  fa

;----------------
; Load FA from hl
;----------------
dload:
    ld      de,fa
    ld      bc,6
    ldir
    ret

