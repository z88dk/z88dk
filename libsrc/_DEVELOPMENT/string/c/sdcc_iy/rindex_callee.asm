
; BSD
; char *rindex_callee(const char *s, int c)

SECTION code_string

PUBLIC _rindex_callee

EXTERN _strrchr_callee

defc _rindex_callee = _strrchr_callee

INCLUDE "string/z80/asm_rindex.asm"
