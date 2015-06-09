
; float strtof(const char *nptr, char **endptr)

SECTION code_stdlib

PUBLIC strtof

EXTERN strtod

defc strtof = strtod
