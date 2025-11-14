SECTION   code_fp_math32
PUBLIC    div2
EXTERN    _m32_div2f

IFNDEF __CLASSIC
defc   div2 = _m32_div2f
ELSE

; Classic has a non-fastcall implementation

div2:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_div2f

; SDCC bridge for Classic
PUBLIC _div2
defc _div2 = div2

ENDIF
