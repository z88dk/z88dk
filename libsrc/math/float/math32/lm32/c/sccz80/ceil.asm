SECTION   code_fp_math32
PUBLIC    ceil
EXTERN    _m32_ceilf

IFNDEF __CLASSIC
defc   ceil = _m32_ceilf
ELSE

; Classic has a non-fastcall implementation

ceil:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_ceilf

; SDCC bridge for Classic
PUBLIC _ceil
defc _ceil = ceil


; Clang bridge for Classic
PUBLIC _ceilf
defc _ceilf = ceil

ENDIF
