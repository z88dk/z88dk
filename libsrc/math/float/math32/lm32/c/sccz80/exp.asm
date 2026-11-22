SECTION   code_fp_math32
PUBLIC    exp
EXTERN    _m32_expf

IFNDEF __CLASSIC
defc   exp = _m32_expf
ELSE

; Classic has a non-fastcall implementation

exp:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_expf

; SDCC bridge for Classic
PUBLIC _exp
defc _exp = exp


; Clang bridge for Classic
PUBLIC _expf
defc _expf = exp

ENDIF
