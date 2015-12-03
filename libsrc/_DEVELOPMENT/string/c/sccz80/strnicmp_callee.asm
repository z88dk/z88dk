
; int strnicmp(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strnicmp_callee

EXTERN strncasecmp_callee

defc strnicmp_callee = strncasecmp_callee
