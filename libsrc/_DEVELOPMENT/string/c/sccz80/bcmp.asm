
; BSD
; int bcmp (const void *b1, const void *b2, size_t len)

SECTION code_clib
SECTION code_string

PUBLIC bcmp

EXTERN memcmp

defc bcmp = memcmp
