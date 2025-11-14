SECTION   code_fp_math32
PUBLIC    exp10
EXTERN    _m32_exp10f

IFNDEF __CLASSIC
defc   exp10 = _m32_exp10f
ELSE

; Classic has a non-fastcall implementation

exp10:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_exp10f

; SDCC bridge for Classic
PUBLIC _exp10
defc _exp10 = exp10


; Clang bridge for Classic
PUBLIC _exp10f
defc _exp10f = exp10

ENDIF
