
; void _imaxdiv_(imaxdiv_t *md, intmax_t numer, intmax_t denom)

SECTION code_clib
SECTION code_inttypes

PUBLIC asm__imaxdiv_

IFDEF __SDCC

   EXTERN asm__lldiv
   defc asm__imaxdiv_ = asm__lldiv

ELSE

   EXTERN asm__ldiv
   defc asm__imaxdiv_ = asm__ldiv

ENDIF
