; BSD
; int bcmp (const void *b1, const void *b2, size_t len)

SECTION code_clib
SECTION code_string

MODULE _bcmp_callee_sdcc
GLOBAL _bcmp_callee
GLOBAL bcmp_callee

defc _bcmp_callee = bcmp_callee

