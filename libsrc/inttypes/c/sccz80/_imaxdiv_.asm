
; void _imaxdiv_(imaxdiv_t *md, intmax_t numer, intmax_t denom)

SECTION code_clib
SECTION code_inttypes

PUBLIC _imaxdiv_

EXTERN _ldiv_

defc _imaxdiv_ = _ldiv_

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC __imaxdiv_
defc __imaxdiv_ = _imaxdiv_
ENDIF

