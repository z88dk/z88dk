; BSD
; char *rindex(const char *s, int c)

SECTION code_clib
SECTION code_string

MODULE _rindex_callee_sdcc
GLOBAL _rindex_callee
GLOBAL rindex_callee

defc _rindex_callee = rindex_callee

