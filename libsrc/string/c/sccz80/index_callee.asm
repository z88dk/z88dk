
; BSD
; char *index(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC index_callee

EXTERN strchr_callee

defc index_callee = strchr_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _index_callee
defc _index_callee = index_callee
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___index_callee
defc ___index_callee = index_callee
ENDIF

