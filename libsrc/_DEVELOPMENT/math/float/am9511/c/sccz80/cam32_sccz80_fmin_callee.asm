
; float _fmin_callee (float left, float right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sccz80_fmin_callee

EXTERN  asm_am9511_compare

    ; minimum of two sccz80 floats
    ;
    ; enter : stack = sccz80_float left, sccz80_float right, ret
    ;
    ; exit  :  DEHL = sccz80_float
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

.cam32_sccz80_fmin_callee 
    call asm_am9511_compare ; compare two floats on the stack
    jr NC,left
    pop af                  ; ret
    pop hl                  ; pop right
    pop de
    pop bc                  ; pop left
    pop bc
    push af
    ret                     ; return DEHL = sccz80_float min

.left
    pop af                  ; ret
    pop bc                  ; pop right
    pop bc
    pop hl                  ; pop left
    pop de
    push af
    ret                     ; return DEHL = sccz80_float min
