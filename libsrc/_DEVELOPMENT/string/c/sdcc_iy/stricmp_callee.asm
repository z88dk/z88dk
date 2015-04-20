
; int stricmp_callee(const char *s1, const char *s2)

SECTION code_string

PUBLIC _stricmp_callee

EXTERN _strcasecmp_callee

defc _stricmp_callee = _strcasecmp_callee

INCLUDE "string/z80/asm_stricmp.asm"
