
; float strtof(const char *nptr, char **endptr)

SECTION code_clib
SECTION code_stdlib

PUBLIC strtof_callee

EXTERN strtod_callee

defc strtof_callee = strtod_callee
