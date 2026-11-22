
; uintmax_t strtoumax_callee(const char *nptr, char **endptr, int base)

SECTION code_clib
SECTION code_inttypes

PUBLIC _strtoumax_callee

EXTERN _strtoull_callee

defc _strtoumax_callee = _strtoull_callee
