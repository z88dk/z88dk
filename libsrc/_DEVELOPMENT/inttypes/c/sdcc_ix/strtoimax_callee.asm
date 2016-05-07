
; intmax_t strtoimax_callee(const char *nptr, char **endptr, int base)

SECTION code_clib
SECTION code_inttypes

PUBLIC _strtoimax_callee

EXTERN _strtoll_callee

defc _strtoimax_callee = _strtoll_callee
