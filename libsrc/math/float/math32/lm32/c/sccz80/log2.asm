SECTION   code_fp_math32
PUBLIC    log2
EXTERN    _m32_log2f

IFNDEF __CLASSIC
defc   log2 = _m32_log2f
ELSE

; Classic has a non-fastcall implementation

log2:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_log2f

; SDCC bridge for Classic
PUBLIC _log2
defc _log2 = log2


; Clang bridge for Classic
PUBLIC _log2f
defc _log2f = log2

ENDIF
