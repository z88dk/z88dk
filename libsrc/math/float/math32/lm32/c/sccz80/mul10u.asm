SECTION   code_fp_math32
PUBLIC    mul10u
EXTERN    _m32_mul10uf

IFNDEF __CLASSIC
defc   mul10u = _m32_mul10uf
ELSE

; Classic has a non-fastcall implementation

mul10u:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_mul10uf

; SDCC bridge for Classic
PUBLIC _mul10u
defc _mul10u = mul10u


; Clang bridge for Classic
PUBLIC _mult10u
defc _mult10u = mul10u

ENDIF
