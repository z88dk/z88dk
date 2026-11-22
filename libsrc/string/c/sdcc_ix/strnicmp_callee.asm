
; int strnicmp_callee(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _strnicmp_callee

EXTERN _strncasecmp_callee

defc _strnicmp_callee = _strncasecmp_callee
