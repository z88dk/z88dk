SECTION   code_fp_math32
PUBLIC    fabs
EXTERN    _m32_fabsf

IFNDEF __CLASSIC
defc   fabs = _m32_fabsf
ELSE

; Classic has a non-fastcall implementation

fabs:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_fabsf

; SDCC bridge for Classic
PUBLIC _fabs
defc _fabs = fabs


; Clang bridge for Classic
PUBLIC _fabsf
defc _fabsf = fabs

ENDIF
