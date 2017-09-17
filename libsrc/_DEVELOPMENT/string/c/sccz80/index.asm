
; BSD
; char *index(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC index

EXTERN strchr

defc index = strchr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _index
defc _index = index
ENDIF

