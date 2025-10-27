SECTION   code_fp_math32
PUBLIC    sinh
EXTERN    _m32_sinhf

IFNDEF __CLASSIC
defc   sinh = _m32_sinhf
ELSE

; Classic has a non-fastcall implementation

sinh:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_sinhf

; SDCC bridge for Classic
PUBLIC _sinh
defc _sinh = sinh

ENDIF
