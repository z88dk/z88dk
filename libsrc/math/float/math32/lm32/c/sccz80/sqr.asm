SECTION   code_fp_math32
PUBLIC    sqr
EXTERN    _m32_sqrf

IFNDEF __CLASSIC
defc   sqr = _m32_sqrf
ELSE

; Classic has a non-fastcall implementation

sqr:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_sqrf

; SDCC bridge for Classic
PUBLIC _sqr
defc _sqr = sqr

ENDIF
