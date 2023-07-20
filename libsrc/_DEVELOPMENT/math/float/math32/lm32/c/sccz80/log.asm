SECTION   code_fp_math32
PUBLIC    log
EXTERN    _m32_logf

IFNDEF __CLASSIC
defc   log = _m32_logf
ELSE

; Classic has a non-fastcall implementation

log:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    jp _m32_logf

; SDCC bridge for Classic
PUBLIC _log
defc _log = log


; Clang bridge for Classic
PUBLIC _logf
defc _logf = log

ENDIF
