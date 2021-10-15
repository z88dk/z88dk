
SECTION code_clib
SECTION code_l_sccz80

PUBLIC      dldpsh
PUBLIC      dpush
EXTERN      fa

;-----------------------------------------
; Load FA from (hl) and push FA onto stack
;-----------------------------------------
dldpsh:
    ld      de,fa
    ld      b,6
loop:
    ld      a,(hl)
    ld      (de),a
    inc     de
    inc     hl
    dec     b
    jp      NZ,loop

;------------------------------------------
; Push FA onto stack (under return address)
;------------------------------------------
dpush:
    pop     de
    ld      hl,(fa+4)
    push    hl
    ld      hl,(fa+2)
    push    hl
    ld      hl,(fa)
    push    hl
    ex      de,hl
    jp      (hl)
