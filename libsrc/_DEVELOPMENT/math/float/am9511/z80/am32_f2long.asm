
SECTION code_fp_am9511

EXTERN  l_neg_dehl
EXTERN asm_am9511_zero, asm_am9511_max

PUBLIC asm_am9511_f2slong
PUBLIC asm_am9511_f2ulong
PUBLIC asm_am9511_f2sint
PUBLIC asm_am9511_f2uint


; Convert floating point number to long
asm_am9511_f2sint:
asm_am9511_f2uint:
asm_am9511_f2slong:
asm_am9511_f2ulong:
    ld b,d
    ld a,d                      ;Holds sign + 7bits of exponent
    rl e
    rla                         ;a = Exponent
    and a
    jp Z,asm_am9511_zero        ;exponent was 0, return 0
    cp $7e + 32
    jp NC,asm_am9511_max        ;number too large
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

