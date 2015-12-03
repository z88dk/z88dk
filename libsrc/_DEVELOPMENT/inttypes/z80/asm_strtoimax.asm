
; intmax_t strtoimax(const char *nptr, char **endptr, int base)

SECTION code_clib
SECTION code_inttypes

PUBLIC asm_strtoimax

EXTERN asm_strtol

defc asm_strtoimax = asm_strtol
