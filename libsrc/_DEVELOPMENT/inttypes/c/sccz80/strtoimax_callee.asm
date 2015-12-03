
; intmax_t strtoimax(const char *nptr, char **endptr, int base)

SECTION code_clib
SECTION code_inttypes

PUBLIC strtoimax_callee

EXTERN strtol_callee

defc strtoimax_callee = strtol_callee
