; BSD
; char *index(const char *s, int c)

SECTION code_clib
SECTION code_string

MODULE _index_callee_sdcc
GLOBAL _index_callee
GLOBAL index_callee

defc _index_callee = index_callee

