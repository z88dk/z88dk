
; uintmax_t strtoumax(const char *nptr, char **endptr, int base)

SECTION code_inttypes

PUBLIC strtoumax_callee

EXTERN strtoul_callee

defc strtoumax_callee = strtoul_callee

INCLUDE "inttypes/z80/asm_strtoumax.asm"
