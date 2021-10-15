
SECTION code_clib
SECTION code_l_sccz80

PUBLIC      dload
EXTERN      fa

;----------------
; Load FA from hl
;----------------
dload:
    ld      de,fa
IF __CPU_INTEL__
    ld      c,a
    ld      b,6
loop:
    ld      a,(hl)
    ld      (de),a
    inc     hl
    inc     de
    dec     b
    jp      NZ,loop
    ld      a,c
ELSE
    ld      bc,6
    ldir
ENDIF
    ret

