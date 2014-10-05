
; int stricmp(const char *s1, const char *s2)

SECTION seg_code_string

PUBLIC _stricmp

EXTERN _strcasecmp

defc _stricmp = _strcasecmp

INCLUDE "string/z80/asm_stricmp.asm"
