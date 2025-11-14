
; float __fspoly (const float x, const float d[], uint16_t n)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sccz80_fspoly

EXTERN m32_fspoly_callee


.cm32_sccz80_fspoly

    ; evaluation of a polynomial function
    ;
    ; enter : stack = float x, float d[], uint16_t n, ret
    ;
    ; exit  : dehl  = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    pop af                      ; my return
    pop hl                      ; (uint16_t)n
    pop de                      ; (float*)d

    exx
    pop hl                      ; (float)x
    pop de 

    exx
    push af                     ; my return
    push hl                     ; (uint16_t)n
    push de                     ; (float*)d

    exx
    push de                     ; (float)x
    push hl

    call m32_fspoly_callee
    
    pop af                      ; my return
    push af
    push af
    push af
    push af
    push af
    ret
