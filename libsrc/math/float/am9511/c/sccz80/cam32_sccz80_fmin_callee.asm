
; float _fmin_callee (float left, float right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sccz80_fmin_callee

IFDEF __CPU_INTEL__

EXTERN _am9511_fmin_callee
defc cam32_sccz80_fmin_callee = _am9511_fmin_callee

ELSE

EXTERN  asm_am9511_compare_sccz80

    ; minimum of two sccz80 floats
    ;
    ; enter : stack = sccz80_float left, sccz80_float right, ret
    ;
    ; exit  :  DEHL = sccz80_float
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

.cam32_sccz80_fmin_callee 
    call asm_am9511_compare_sccz80  ; compare two floats on the stack
    jp C,left
    pop bc                  ; ret
    pop hl                  ; pop right
    pop de
    pop af                  ; pop left
    pop af
    push bc
    ret                     ; return DEHL = sccz80_float min

.left
    pop bc                  ; ret
    pop af                  ; pop right
    pop af
    pop hl                  ; pop left
    pop de
    push bc
    ret                     ; return DEHL = sccz80_float min

ENDIF
