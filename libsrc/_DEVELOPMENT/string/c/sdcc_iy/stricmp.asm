
; int stricmp(const char *s1, const char *s2)

PUBLIC _stricmp

EXTERN _strcasecmp

_stricmp:

   jp _strcasecmp

   INCLUDE "string/z80/asm_stricmp.asm"
