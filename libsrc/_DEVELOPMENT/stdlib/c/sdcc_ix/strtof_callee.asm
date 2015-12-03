
; float strtof(const char *nptr, char **endptr)

SECTION code_clib
SECTION code_stdlib

PUBLIC _strtof_callee

EXTERN _strtod_callee

defc _strtof_callee = _strtod_callee
