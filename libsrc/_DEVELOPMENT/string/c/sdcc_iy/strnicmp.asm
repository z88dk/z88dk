
; int strnicmp(const char *s1, const char *s2, size_t n)

PUBLIC _strnicmp

EXTERN _strncasecmp

_strnicmp:

   jp _strncasecmp

   INCLUDE "string/z80/asm_strnicmp.asm"
