
; float strtof(const char *nptr, char **endptr)

SECTION code_clib
SECTION code_stdlib

PUBLIC _strtof

EXTERN _strtod

defc _strtof = _strtod
