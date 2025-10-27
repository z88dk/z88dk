
; float _fmax_callee (float left, float right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sdcc_fmax_callee

EXTERN  asm_am9511_compare

    ; maximum of two sdcc floats
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret
    ;
    ; exit  : DEHL = sdcc_float
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

.cam32_sdcc_fmax_callee
    call asm_am9511_compare ; compare two floats on the stack
    jr C,right
    pop af                  ; ret
    pop hl                  ; pop left
    pop de
    pop bc                  ; pop right
    pop bc
    push af
    ret                     ; return DEHL = sdcc_float

.right
    pop af                  ; ret
    pop bc                  ; pop left
    pop bc
    pop hl                  ; pop right
    pop de
    push af
    ret                     ; return DEHL = sdcc_float
