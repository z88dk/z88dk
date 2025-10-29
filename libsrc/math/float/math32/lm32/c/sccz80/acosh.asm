SECTION   code_fp_math32
PUBLIC    acosh
EXTERN    _m32_acoshf

IFNDEF __CLASSIC
defc   acosh = _m32_acoshf
ELSE

; Classic has a non-fastcall implementation

acosh:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_acoshf

; SDCC bridge for Classic
PUBLIC _acosh
defc _acosh = acosh

ENDIF
