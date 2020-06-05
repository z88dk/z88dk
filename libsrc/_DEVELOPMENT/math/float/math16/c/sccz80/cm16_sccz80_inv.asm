
SECTION code_fp_math16
PUBLIC cm16_sccz80_inv

EXTERN cm16_sccz80_read1, asm_f16_inv

    ; invert sccz80 half
    ;
    ; enter : stack = sccz80_half number, ret
    ;
    ; exit  :  HL = sccz80_half(1/number)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

.cm16_sccz80_inv
    call cm16_sccz80_read1
    jp asm_f16_inv

