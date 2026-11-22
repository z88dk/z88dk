
; BSD
; char *index_callee(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC _index_callee

EXTERN _strchr_callee

defc _index_callee = _strchr_callee
