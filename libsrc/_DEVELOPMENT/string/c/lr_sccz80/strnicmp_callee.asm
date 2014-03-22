
; int strnicmp(const char *s1, const char *s2, size_t n)

XDEF strnicmp_callee

LIB strncasecmp_callee

defc strnicmp_callee = strncasecmp_callee

INCLUDE "../../z80/asm_strnicmp.asm"
