
; intmax_t strtoimax(const char *nptr, char **endptr, int base)

SECTION code_inttypes

PUBLIC strtoimax_callee

EXTERN strtol_callee

defc strtoimax_callee = strtol_callee

INCLUDE "inttypes/z80/asm_strtoimax.asm"
