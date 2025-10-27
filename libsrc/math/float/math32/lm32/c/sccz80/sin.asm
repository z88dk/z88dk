SECTION   code_fp_math32
PUBLIC    sin
EXTERN    _m32_sinf

IFNDEF __CLASSIC
defc   sin = _m32_sinf
ELSE

; Classic has a non-fastcall implementation

sin:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_sinf

; SDCC bridge for Classic
PUBLIC _sin
defc _sin = sin


; Clang bridge for Classic
PUBLIC _sinf
defc _sinf = sin

ENDIF
