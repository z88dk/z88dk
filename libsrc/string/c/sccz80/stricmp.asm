
; int stricmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC stricmp

EXTERN strcasecmp

defc stricmp = strcasecmp

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _stricmp
defc _stricmp = stricmp
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___stricmp
defc ___stricmp = stricmp
ENDIF

