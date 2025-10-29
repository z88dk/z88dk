SECTION   code_fp_math32
PUBLIC    inv
EXTERN    _m32_invf

IFNDEF __CLASSIC
defc   inv = _m32_invf
ELSE

; Classic has a non-fastcall implementation

inv:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_invf

; SDCC bridge for Classic
PUBLIC _inv
defc _inv = inv

ENDIF
