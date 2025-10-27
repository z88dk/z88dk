
; BSD
; char *rindex_callee(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC _rindex_callee

EXTERN _strrchr_callee

defc _rindex_callee = _strrchr_callee
