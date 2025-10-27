SECTION   code_fp_math32
PUBLIC    tanh
EXTERN    _m32_tanhf

IFNDEF __CLASSIC
defc   tanh = _m32_tanhf
ELSE

; Classic has a non-fastcall implementation

tanh:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_tanhf

; SDCC bridge for Classic
PUBLIC _tanh
defc _tanh = tanh

ENDIF
