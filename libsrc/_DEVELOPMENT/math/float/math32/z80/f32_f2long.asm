
SECTION code_fp_math32

EXTERN  l_neg_dehl
EXTERN m32_fszero, m32_fsmax

PUBLIC m32_f2slong
PUBLIC m32_f2ulong
PUBLIC m32_f2sint
PUBLIC m32_f2uint


; Convert floating point number to long
m32_f2sint:
m32_f2uint:
m32_f2slong:
m32_f2ulong:
    ld b,d
    ld a,d                      ;Holds sign + 7bits of exponent
    rl e
    rla                         ;a = Exponent
    and a
    jp Z,m32_fszero             ;exponent was 0, return 0
    cp $7e + 32
    jp NC,m32_fsmax             ;number too large
    ; e register is rotated by bit, restore the hidden bit and rotate back
    scf
    rr  e
    ld d,e
    ld e,h
    ld h,l
    ld l,0
loop:
    srl d                       ;fill with 0
    rr e
    rr h
    rr l
    inc a
    cp $7e + 32
    jr NZ,loop
    rl b                        ;check sign bit
    call C,l_neg_dehl
    ret

