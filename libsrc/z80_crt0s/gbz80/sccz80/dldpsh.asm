
        SECTION code_crt0_sccz80
        PUBLIC  dldpsh
        PUBLIC  dpush
        EXTERN  fa


;-----------------------------------------
; Load FA from (hl) and push FA onto stack
;-----------------------------------------
dldpsh: ld      de,fa
        ld      bc,6
        ldir
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
