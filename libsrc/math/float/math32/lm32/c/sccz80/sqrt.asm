SECTION   code_fp_math32
PUBLIC    sqrt
EXTERN    _m32_sqrtf

IFNDEF __CLASSIC
defc   sqrt = _m32_sqrtf
ELSE

; Classic has a non-fastcall implementation

sqrt:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_sqrtf

; SDCC bridge for Classic
PUBLIC _sqrt
defc _sqrt = sqrt


; Clang bridge for Classic
PUBLIC _sqrtf
defc _sqrtf = sqrt

ENDIF
