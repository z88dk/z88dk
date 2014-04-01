
; int strnicmp(const char *s1, const char *s2, size_t n)

XDEF strnicmp

LIB strncasecmp

strnicmp:

   jp strncasecmp

   INCLUDE "string/z80/asm_strnicmp.asm"
