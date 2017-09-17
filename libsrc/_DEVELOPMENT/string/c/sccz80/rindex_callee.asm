
; BSD
; char *rindex(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC rindex_callee

EXTERN strrchr_callee

defc rindex_callee = strrchr_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _rindex_callee
defc _rindex_callee = rindex_callee
ENDIF

