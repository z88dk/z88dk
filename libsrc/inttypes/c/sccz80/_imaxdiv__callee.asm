
; void _imaxdiv_(imaxdiv_t *md, intmax_t numer, intmax_t denom)

SECTION code_clib
SECTION code_inttypes

PUBLIC _imaxdiv__callee

EXTERN _ldiv__callee

defc _imaxdiv__callee = _ldiv__callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC __imaxdiv__callee
defc __imaxdiv__callee = _imaxdiv__callee
ENDIF

