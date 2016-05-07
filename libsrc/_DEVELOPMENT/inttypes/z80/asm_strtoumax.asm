
; uintmax_t strtoumax(const char *nptr, char **endptr, int base)

SECTION code_clib
SECTION code_inttypes

PUBLIC asm_strtoumax

IFDEF __SDCC

   EXTERN asm_strtoull
   defc asm_strtoumax = asm_strtoull

ELSE

   EXTERN asm_strtoul
   defc asm_strtoumax = asm_strtoul

ENDIF
