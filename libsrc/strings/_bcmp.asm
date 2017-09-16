; BSD
; int bcmp (const void *b1, const void *b2, size_t len)

SECTION code_clib
SECTION code_string

MODULE _bcmp_sdcc
GLOBAL _bcmp
GLOBAL bcmp

defc _bcmp = bcmp

