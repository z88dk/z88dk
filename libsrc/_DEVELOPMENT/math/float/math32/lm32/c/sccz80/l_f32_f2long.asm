
    SECTION code_fp_math32

    PUBLIC  l_f32_f2slong
    PUBLIC  l_f32_f2ulong
    PUBLIC  l_f32_f2sint
    PUBLIC  l_f32_f2uint

    EXTERN  l_long_neg
    EXTERN  l_f32_zero

; Convert floating point number to long
.l_f32_f2sint
.l_f32_f2uint
.l_f32_f2slong
.l_f32_f2ulong
    ld b,d
    ld  a,d                 ;Holds sign + 7bits of exponent
    rl e
    rla                     ;a = Exponent
    and a
    jp Z,l_f32_zero         ;Exponent was 0, return 0
    cp $7e + 32
    jp NC,l_f32_zero        ;Number too large
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
    call C,l_long_neg
    ret
