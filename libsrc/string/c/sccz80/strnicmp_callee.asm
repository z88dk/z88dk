
; int strnicmp(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strnicmp_callee

EXTERN strncasecmp_callee

defc strnicmp_callee = strncasecmp_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strnicmp_callee
defc _strnicmp_callee = strnicmp_callee
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strnicmp_callee
defc ___strnicmp_callee = strnicmp_callee
ENDIF

