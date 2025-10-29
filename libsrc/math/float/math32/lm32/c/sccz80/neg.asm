SECTION   code_fp_math32
PUBLIC    neg
EXTERN    _m32_negf

IFNDEF __CLASSIC
defc   neg = _m32_negf
ELSE

; Classic has a non-fastcall implementation

neg:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_negf

; SDCC bridge for Classic
PUBLIC _neg
defc _neg = neg

ENDIF
