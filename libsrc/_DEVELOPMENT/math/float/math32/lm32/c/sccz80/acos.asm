SECTION   code_fp_math32
PUBLIC    acos
EXTERN    _m32_acosf

IFNDEF __CLASSIC
defc   acos = _m32_acosf
ELSE

; Classic has a non-fastcall implementation

acos:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_acosf

; SDCC bridge for Classic
PUBLIC _acos
defc _acos = acos

ENDIF
