SECTION   code_fp_math32
PUBLIC    cos
EXTERN    _m32_cosf

IFNDEF __CLASSIC
defc   cos = _m32_cosf
ELSE

; Classic has a non-fastcall implementation

cos:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_cosf

; SDCC bridge for Classic
PUBLIC _cos
defc _cos = cos


; Clang bridge for Classic
PUBLIC _cosf
defc _cosf = cos

ENDIF
