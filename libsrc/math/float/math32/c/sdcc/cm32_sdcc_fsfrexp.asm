
SECTION code_fp_math32

PUBLIC cm32_sdcc_frexp

EXTERN m32_fsfrexp_callee

; float frexpf(float x, int16_t *pw2);

.cm32_sdcc_frexp

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
    call m32_fsfrexp_callee

    pop af                      ; my return
    push af
    push af
    push af
    push af
    ret
