
; long __ldiv_u_callee (long left, long right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sccz80_ldiv_u_callee

EXTERN asm_am9511_ldiv_callee

    ; divide sccz80 unsigned long by sccz80 unsigned long
    ;
    ; enter : stack = sccz80_long left, ret
    ;          DEHL = sccz80_long right
    ;
    ; exit  :  DEHL = sccz80_long(left-right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

.cam32_sccz80_ldiv_u_callee
    ld a,d
    and $7f                 ; unsigned divisor
    ld d,a
    jp asm_am9511_ldiv_callee
                            ; enter stack = sccz80_long left, ret
                            ;        DEHL = sccz80_long right
                            ; return DEHL = sccz80_long
