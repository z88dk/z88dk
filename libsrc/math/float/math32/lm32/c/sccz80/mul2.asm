SECTION   code_fp_math32
PUBLIC    mul2
EXTERN    _m32_mul2f

IFNDEF __CLASSIC
defc   mul2 = _m32_mul2f
ELSE

; Classic has a non-fastcall implementation

mul2:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_mul2f

; SDCC bridge for Classic
PUBLIC _mul2
defc _mul2 = mul2

ENDIF
