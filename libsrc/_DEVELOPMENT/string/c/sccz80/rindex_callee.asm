
; BSD
; char *rindex(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC rindex_callee

EXTERN strrchr_callee

defc rindex_callee = strrchr_callee
