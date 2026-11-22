
SECTION code_clib
SECTION code_l_sccz80
PUBLIC  dldpsh
PUBLIC  dpush
EXTERN  fa


;-----------------------------------------
; Load FA from (hl) and push FA onto stack
;-----------------------------------------
dldpsh: ld      de,fa
        ld      b,6
loop:
        ld      a,(hl+)
        ld      (de),a
        inc     de
        dec     b
        jr      nz,loop
;------------------------------------------
; Push FA onto stack (under return address)
;------------------------------------------
dpush:  pop     de
        ld      hl,fa+5
        ld      a,(hl-)
        ld      b,a
        ld      a,(hl-)
        ld      c,a
        push    bc
        ld      a,(hl-)
        ld      b,a
        ld      a,(hl-)
        ld      c,a
        push    bc
        ld      a,(hl-)
        ld      b,a
        ld      c,(hl)
        push    bc
        push    de
        ret
