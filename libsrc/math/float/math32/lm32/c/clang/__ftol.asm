

SECTION code_fp_math32

PUBLIC __ftol

EXTERN l_neg_dehl

;dehl = long(iybc)
__ftol:
__ftoul:
    push iy
    pop de
    ld hl,bc

    ld b,d
    ld  a,d                 ;Holds sign + 7bits of exponent
    rl e
    rla                     ;a = Exponent
    and a
    jp Z,zero         ;Exponent was 0, return 0
    cp $7e + 32
    jp NC,zero        ;Number too large
    ; e register is rotated by bit, restore the hidden bit and rotate back
    scf
    rr e
    ld d,e
    ld e,h
    ld h,l
    ld l,0
.loop
    srl d                   ;Fill with 0
    rr e
    rr h
    rr l
    rr c
    inc a
    cp $7e + 32
    jr NZ,loop
    rl b                    ;Check sign bit
    call C,l_neg_dehl
    ret

zero:
    ld hl,0
    ld d,h
    ld e,l
    ret
