
; void _imaxdiv_(imaxdiv_t *md, intmax_t numer, intmax_t denom)

SECTION code_clib
SECTION code_inttypes

PUBLIC __imaxdiv_

EXTERN __lldiv_

defc __imaxdiv_ = __lldiv_
