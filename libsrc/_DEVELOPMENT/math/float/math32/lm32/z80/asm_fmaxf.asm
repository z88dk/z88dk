
; float _fmaxf (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math32

PUBLIC asm_fmaxf

EXTERN m32_fsmax

    ; convert sdcc float to error infinity with correct sign
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(infinity)
    ;
    ; uses  : af, bc, de, hl

DEFC  asm_fmaxf = m32_fsmax                     ; enter stack = ret
                                                ;        DEHL = d32_float
                                                ; return DEHL = d32_float
