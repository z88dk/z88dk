;
;    Fixed Point functions
;
;    long i2f (int v) __z88dk_fastcall;
;    integer to fixed point 26.6;
;

    SECTION code_clib
    PUBLIC  i2f
    PUBLIC  _i2f
    

.i2f
._i2f
    ;pop     bc
    ;pop     hl
    ;push    hl
    ;push    bc

;; put long result in DEHL
    ld      e,h
    ld      h,l
    ld      l,0
    ld      d,l
    bit     7,e
    jr      Z,noneg
    dec     d
    inc     l   ; when rotated it will become bit 31
    scf         ; when rotated it will become bit 30

.noneg
    rr      d
    rr      e
    rr      h
    rr      l

    rr      d
    rr      e
    rr      h
    rr      l

    ret
