
; uintmax_t strtoumax(const char *nptr, char **endptr, int base)

SECTION code_clib
SECTION code_inttypes

PUBLIC asm_strtoumax

EXTERN asm_strtoul

defc asm_strtoumax = asm_strtoul
