SECTION   code_fp_math32
PUBLIC    atan
EXTERN    _m32_atanf

IFNDEF __CLASSIC
defc   atan = _m32_atanf
ELSE

; Classic has a non-fastcall implementation

atan:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_atanf

; SDCC bridge for Classic
PUBLIC _atan
defc _atan = atan

ENDIF
