
SECTION code_fp_math32

PUBLIC cm32_sdcc_ldexp

EXTERN m32_fsldexp_callee

; float ldexpf(float x, int16_t pw2);

.cm32_sdcc_ldexp

    ; Entry:
    ; Stack: int right, float left, ret

    pop af                      ; my return
    pop hl                      ; (float)x
    pop de
    pop bc                      ; pw2
    push af                     ; my return   
    push bc                     ; pw2
    push de                     ; (float)x
    push hl
    call m32_fsldexp_callee

    pop af                      ; my return
    push af
    push af
    push af
    push af
    ret
    
