
; intmax_t strtoimax(const char *nptr, char **endptr, int base)

SECTION code_clib
SECTION code_inttypes

PUBLIC _strtoimax

EXTERN _strtoll

defc _strtoimax = _strtoll
