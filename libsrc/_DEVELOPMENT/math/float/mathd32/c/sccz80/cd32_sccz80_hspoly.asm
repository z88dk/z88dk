
; float __fspoly (const float x, const float d[], uint16_t n)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sccz80_dspoly

EXTERN md32_fspoly_callee

.cd32_sccz80_dspoly

    ; evaluation of a polynomial function
    ;
    ; enter : stack = uint16_t n, float d[], float x, ret
    ;
    ; exit  : dehl  = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    pop af                      ; my return
    pop hl                      ; (float)x
    pop de

    exx
    pop hl                      ; (float*)d
    pop de                      ; (uint16_t)n

    push af                     ; my return
    push de                     ; (uint16_t)n
    push hl                     ; (float*)d

    exx
    push de                      ; (float)x
    push hl

    call md32_fspoly_callee
    
    pop hl                      ; my return
    xor a
    push af
    push af
    push af
    push af  
    jp (hl)

