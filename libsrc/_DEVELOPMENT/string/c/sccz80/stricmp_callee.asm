
; int stricmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC stricmp_callee

EXTERN strcasecmp_callee

defc stricmp_callee = strcasecmp_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _stricmp_callee
defc _stricmp_callee = stricmp_callee
ENDIF

