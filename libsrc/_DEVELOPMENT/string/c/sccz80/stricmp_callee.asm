
; int stricmp(const char *s1, const char *s2)

PUBLIC stricmp_callee

EXTERN strcasecmp_callee

;defc stricmp_callee = strcasecmp_callee

stricmp_callee:

   jp strcasecmp_callee

INCLUDE "string/z80/asm_stricmp.asm"
