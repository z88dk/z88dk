
; long __ldiv (long left, long right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sdcc_ldiv

EXTERN cam32_sdcc_readr, asm_am9511_ldiv

.cam32_sdcc_ldiv

    ; divide sdcc long by sdcc long
    ;
    ; enter : stack = sdcc_long right, sdcc_long left, ret
    ;
    ; exit  : DEHL = sdcc_long(left/right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cam32_sdcc_readr
    jp asm_am9511_ldiv      ; enter stack = sdcc_long right, sdcc_long left, ret
                            ;        DEHL = sdcc_long right
                            ; return DEHL = sdcc_long
