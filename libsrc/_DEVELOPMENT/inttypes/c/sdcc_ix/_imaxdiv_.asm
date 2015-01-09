
; void _imaxdiv_(imaxdiv_t *md, intmax_t numer, intmax_t denom)

SECTION code_inttypes

PUBLIC __imaxdiv_

EXTERN __ldiv_

defc __imaxdiv_ = __ldiv_

INCLUDE "inttypes/z80/asm__imaxdiv_.asm"
