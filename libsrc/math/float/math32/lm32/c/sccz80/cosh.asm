SECTION   code_fp_math32
PUBLIC    cosh
EXTERN    _m32_coshf

IFNDEF __CLASSIC
defc   cosh = _m32_coshf
ELSE

; Classic has a non-fastcall implementation

cosh:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_coshf

; SDCC bridge for Classic
PUBLIC _cosh
defc _cosh = cosh

ENDIF
