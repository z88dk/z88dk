
; BSD
; char *index(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC index

EXTERN strchr

defc index = strchr
