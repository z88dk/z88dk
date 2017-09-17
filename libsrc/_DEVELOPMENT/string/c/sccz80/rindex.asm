
; BSD
; char *rindex(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC rindex

EXTERN strrchr

defc rindex = strrchr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _rindex
defc _rindex = rindex
ENDIF

