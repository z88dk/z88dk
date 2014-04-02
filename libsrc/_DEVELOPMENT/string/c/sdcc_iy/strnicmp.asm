
; int strnicmp(const char *s1, const char *s2, size_t n)

XDEF _strnicmp

LIB _strncasecmp

_strnicmp:

   jp _strncasecmp

   INCLUDE "string/z80/asm_strnicmp.asm"
