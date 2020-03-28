
; float _fmax (float left, float right)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sdcc_fmax

EXTERN cm32_sdcc_fsread1, cm32_sdcc_fsreadr, m32_compare

    ; maximum of two sdcc floats
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret
    ;
    ; exit  : stack = sdcc_float right, sdcc_float left, ret
    ;          DEHL = sdcc_float
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

.cm32_sdcc_fmax
    call m32_compare        ; compare two floats on the stack
    jp C,cm32_sdcc_fsreadr
    jp cm32_sdcc_fsread1    ; enter  stack = sdcc_float right, sdcc_float left, ret
                            ; return stack = sdcc_float right, sdcc_float left
                            ;         DEHL = sdcc_float max

