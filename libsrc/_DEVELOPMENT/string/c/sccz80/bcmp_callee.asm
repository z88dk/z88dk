
; BSD
; int bcmp (const void *b1, const void *b2, size_t len)

SECTION code_string

PUBLIC bcmp_callee

EXTERN memcmp_callee

defc bcmp_callee = memcmp_callee

INCLUDE "string/z80/asm_bcmp.asm"
