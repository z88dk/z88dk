
; float _fmax_callee (float left, float right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sccz80_fmax_callee

IFDEF __CPU_8085__

EXTERN _am9511_fmax_callee
defc cam32_sccz80_fmax_callee = _am9511_fmax_callee

ELSE


EXTERN  asm_am9511_compare_sccz80

    ; maximum of two sccz80 floats
    ;
    ; enter : stack = sccz80_float left, sccz80_float right, ret
    ;
    ; exit  :  DEHL = sccz80_float
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

.cam32_sccz80_fmax_callee 
    call asm_am9511_compare_sccz80  ; compare two floats on the stack
    jp NC,left
    pop bc                  ; ret
    pop hl                  ; pop right
    pop de
    pop af                  ; pop left
    pop af
    push bc
    ret                     ; return DEHL = sccz80_float max

.left
    pop bc                  ; ret
    pop af                  ; pop right
    pop af
    pop hl                  ; pop left
    pop de
    push bc
    ret                     ; return DEHL = sccz80_float max

ENDIF
