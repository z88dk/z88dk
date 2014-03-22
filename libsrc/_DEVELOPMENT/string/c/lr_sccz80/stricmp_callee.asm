
; int stricmp(const char *s1, const char *s2)

XDEF stricmp_callee

LIB strcasecmp_callee

defc stricmp_callee = strcasecmp_callee

INCLUDE "../../z80/asm_stricmp.asm"
