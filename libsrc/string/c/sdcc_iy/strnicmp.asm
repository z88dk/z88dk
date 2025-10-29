
; int strnicmp(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _strnicmp

EXTERN _strncasecmp

defc _strnicmp = _strncasecmp
