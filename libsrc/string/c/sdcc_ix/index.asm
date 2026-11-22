
; BSD
; char *index(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC _index

EXTERN _strchr

defc _index = _strchr
