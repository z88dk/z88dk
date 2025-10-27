
; void _imaxdiv_(imaxdiv_t *md, intmax_t numer, intmax_t denom)

SECTION code_clib
SECTION code_inttypes

PUBLIC _imaxdiv__callee

EXTERN _ldiv__callee

defc _imaxdiv__callee = _ldiv__callee
