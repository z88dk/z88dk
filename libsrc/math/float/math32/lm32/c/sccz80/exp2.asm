SECTION   code_fp_math32
PUBLIC    exp2
EXTERN    _m32_exp2f

IFNDEF __CLASSIC
defc   exp2 = _m32_exp2f
ELSE

; Classic has a non-fastcall implementation

exp2:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_exp2f

; SDCC bridge for Classic
PUBLIC _exp2
defc _exp2 = exp2


; Clang bridge for Classic
PUBLIC _exp2f
defc _exp2f = exp2

ENDIF
