SECTION   code_fp_math32
PUBLIC    round
EXTERN    _m32_roundf

IFNDEF __CLASSIC
defc   round = _m32_roundf
ELSE

; Classic has a non-fastcall implementation

round:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_roundf

; SDCC bridge for Classic
PUBLIC _round
defc _round = round


; Clang bridge for Classic
PUBLIC _roundf
defc _roundf = round

ENDIF
