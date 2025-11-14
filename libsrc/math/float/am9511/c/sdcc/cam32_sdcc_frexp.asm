
SECTION code_fp_am9511

PUBLIC cam32_sdcc_frexp

EXTERN asm_am9511_frexp_callee

; float frexpf(float x, int16_t *pw2);

.cam32_sdcc_frexp

    ; Entry:
    ; Stack: ptr right, float left, ret
    
    pop af                      ; my return
    pop hl                      ; (float)x
    pop de
    pop bc                      ; (float*)pw2
    push af                     ; my return   
    push bc                     ; (float*)pw2
    push de                     ; (float)x
    push hl
    call asm_am9511_frexp_callee

    pop af                      ; my return
    push af
    push af
    push af
    push af
    ret
