SECTION   code_fp_math32
PUBLIC    atanh
EXTERN    _m32_atanhf

IFNDEF __CLASSIC
defc   atanh = _m32_atanhf
ELSE

; Classic has a non-fastcall implementation

atanh:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_atanhf

; SDCC bridge for Classic
PUBLIC _atanh
defc _atanh = atanh

ENDIF
