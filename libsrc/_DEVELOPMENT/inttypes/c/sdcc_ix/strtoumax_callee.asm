
; uintmax_t strtoumax_callee(const char *nptr, char **endptr, int base)

SECTION code_clib
SECTION code_inttypes

PUBLIC _strtoumax_callee

EXTERN _strtoul_callee

defc _strtoumax_callee = _strtoul_callee
