; BSD
; void bcopy(const void *src, void *dst, size_t len)

SECTION code_clib
SECTION code_string

MODULE _bcopy_sdcc
GLOBAL _bcopy
GLOBAL bcopy

defc _bcopy = bcopy

