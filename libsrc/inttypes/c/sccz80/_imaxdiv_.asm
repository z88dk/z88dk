
; void _imaxdiv_(imaxdiv_t *md, intmax_t numer, intmax_t denom)

SECTION code_clib
SECTION code_inttypes

PUBLIC _imaxdiv_

EXTERN _ldiv_

defc _imaxdiv_ = _ldiv_
