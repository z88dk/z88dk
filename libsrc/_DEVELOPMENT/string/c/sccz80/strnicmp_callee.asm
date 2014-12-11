
; int strnicmp(const char *s1, const char *s2, size_t n)

SECTION code_string

PUBLIC strnicmp_callee

EXTERN strncasecmp_callee

defc strnicmp_callee = strncasecmp_callee

INCLUDE "string/z80/asm_strnicmp.asm"
