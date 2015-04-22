
; intmax_t strtoimax_callee(const char *nptr, char **endptr, int base)

SECTION code_inttypes

PUBLIC _strtoimax_callee

EXTERN _strtol_callee

defc _strtoimax_callee = _strtol_callee

INCLUDE "inttypes/z80/asm_strtoimax.asm"
