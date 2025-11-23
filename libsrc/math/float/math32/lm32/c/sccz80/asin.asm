SECTION   code_fp_math32
PUBLIC    asin
EXTERN    _m32_asinf

IFNDEF __CLASSIC
defc   asin = _m32_asinf
ELSE

; Classic has a non-fastcall implementation

asin:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_asinf

; SDCC bridge for Classic
PUBLIC _asin
defc _asin = asin

ENDIF
