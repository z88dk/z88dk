
; BSD
; char *rindex(const char *s, int c)

SECTION code_string

PUBLIC rindex_callee

EXTERN strrchr_callee

defc rindex_callee = strrchr_callee

INCLUDE "string/z80/asm_rindex.asm"
