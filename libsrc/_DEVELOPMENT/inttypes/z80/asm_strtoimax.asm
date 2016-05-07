
; intmax_t strtoimax(const char *nptr, char **endptr, int base)

SECTION code_clib
SECTION code_inttypes

PUBLIC asm_strtoimax

IFDEF __SDCC

   EXTERN asm_strtoll
   defc asm_strtoimax = asm_strtoll

ELSE

   EXTERN asm_strtol
   defc asm_strtoimax = asm_strtol

ENDIF
