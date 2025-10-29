
; int strnicmp(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strnicmp

EXTERN strncasecmp

defc strnicmp = strncasecmp

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strnicmp
defc _strnicmp = strnicmp
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strnicmp
defc ___strnicmp = strnicmp
ENDIF

