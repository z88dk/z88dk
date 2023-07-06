SECTION   code_fp_math32
PUBLIC    tan
EXTERN    _m32_tanf

IFNDEF __CLASSIC
defc   tan = _m32_tanf
ELSE

; Classic has a non-fastcall implementation

tan:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_tanf

; SDCC bridge for Classic
PUBLIC _tan
defc _tan = tan

ENDIF
