
SECTION code_fp_am9511

PUBLIC cam32_sdcc_ldexp

EXTERN asm_am9511_ldexp_callee

; float ldexpf(float x, int16_t pw2);

.cam32_sdcc_ldexp

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
    call asm_am9511_ldexp_callee

    pop af                      ; my return
    push af
    push af
    push af
    push af
    ret
    
