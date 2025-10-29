SECTION   code_fp_math32
PUBLIC    asinh
EXTERN    _m32_asinhf

IFNDEF __CLASSIC
defc   asinh = _m32_asinhf
ELSE

; Classic has a non-fastcall implementation

asinh:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_asinhf

; SDCC bridge for Classic
PUBLIC _asinh
defc _asinh = asinh

ENDIF
