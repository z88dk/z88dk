SECTION   code_fp_math32
PUBLIC    invsqrt
EXTERN    _m32_invsqrtf

IFNDEF __CLASSIC
defc   invsqrt = _m32_invsqrtf
ELSE

; Classic has a non-fastcall implementation

invsqrt:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_invsqrtf

; SDCC bridge for Classic
PUBLIC _invsqrt
defc _invsqrt = invsqrt

ENDIF
