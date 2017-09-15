; BSD
; void bcopy(const void *src, void *dst, size_t len)

SECTION code_clib
SECTION code_string

MODULE _bcopy_callee_sdcc
GLOBAL _bcopy_callee
GLOBAL bcopy_callee

defc _bcopy_callee = bcopy_callee

