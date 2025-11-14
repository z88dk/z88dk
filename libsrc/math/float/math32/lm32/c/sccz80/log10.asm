SECTION   code_fp_math32
PUBLIC    log10
EXTERN    _m32_log10f

IFNDEF __CLASSIC
defc   log10 = _m32_log10f
ELSE

; Classic has a non-fastcall implementation

log10:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_log10f

; SDCC bridge for Classic
PUBLIC _log10
defc _log10 = log10


; Clang bridge for Classic
PUBLIC _log10f
defc _log10f = log10

ENDIF
