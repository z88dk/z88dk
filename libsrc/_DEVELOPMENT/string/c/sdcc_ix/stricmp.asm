
; int stricmp(const char *s1, const char *s2)

XDEF stricmp

LIB strcasecmp

stricmp:

   jp strcasecmp

   INCLUDE "string/z80/asm_stricmp.asm"
