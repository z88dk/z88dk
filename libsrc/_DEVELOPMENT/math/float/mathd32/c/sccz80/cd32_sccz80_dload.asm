
SECTION code_clib
SECTION code_math

PUBLIC cd32_sccz80_dload

.cd32_sccz80_dload

    ; sccz80 float primitive
    ;
    ; Convert stack from sccz80_float format to d32_float.
    ;
    ; enter : stack = sccz80_float left, ret
    ; enter : DEHL = sccz80_float right
    ;
    ; enter : stack = sccz80_float left, ret, d32_float left
    ; exit  : DEHL = sccz80_float right
    ; 
    ; uses  : af, bc, de, hl

    pop hl                  ; ret from here
    pop af                  ; ret
    pop bc                  ; sccz80_float left
    pop de
    push de
    push bc
    push af                 ; ret
    push de                 ; d32_float left
    push bc
    jp (hl)                 ; ret from here                

