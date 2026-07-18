
; float _fmin_callee (float left, float right)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sccz80_fmin_callee

IFDEF __CPU_INTEL__

; 8085: C helper is already callee and AF-safe for the return path
EXTERN _m32_fminf
defc cm32_sccz80_fmin_callee = _m32_fminf

ELSE

EXTERN  m32_compare

    ; minimum of two sccz80 floats
    ;
    ; enter : stack = sccz80_float left, sccz80_float right, ret
    ;
    ; exit  :  DEHL = sccz80_float
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

.cm32_sccz80_fmin_callee
    call m32_compare        ; compare two floats on the stack
    jr NC,left
    pop bc                  ; ret
    pop hl                  ; right
    pop de
    pop af                  ; discard left
    pop af
    push bc                 ; ret
    ret                     ; DEHL = min (right)

.left
    pop bc                  ; ret
    pop af                  ; discard right
    pop af
    pop hl                  ; left
    pop de
    push bc                 ; ret
    ret                     ; DEHL = min (left)

ENDIF
