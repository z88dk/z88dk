
; int stricmp(const char *s1, const char *s2)

XDEF _stricmp

LIB _strcasecmp

_stricmp:

   jp _strcasecmp

   INCLUDE "string/z80/asm_stricmp.asm"
