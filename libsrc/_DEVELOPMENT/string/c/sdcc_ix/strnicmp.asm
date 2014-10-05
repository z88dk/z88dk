
; int strnicmp(const char *s1, const char *s2, size_t n)

SECTION seg_code_string

PUBLIC _strnicmp

EXTERN _strncasecmp

defc _strnicmp = _strncasecmp

INCLUDE "string/z80/asm_strnicmp.asm"
