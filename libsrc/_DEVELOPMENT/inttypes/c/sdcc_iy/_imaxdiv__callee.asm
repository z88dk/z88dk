
; void _imaxdiv__callee(imaxdiv_t *md, intmax_t numer, intmax_t denom)

SECTION code_clib
SECTION code_inttypes

PUBLIC __imaxdiv__callee

EXTERN __lldiv__callee

defc __imaxdiv__callee = __lldiv__callee
