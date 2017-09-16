; BSD
; void *rawmemchr(const void *mem, int c)

SECTION code_clib
SECTION code_string

MODULE _rawmemchr_callee_sdcc
GLOBAL _rawmemchr_callee
GLOBAL rawmemchr_callee

defc _rawmemchr_callee = rawmemchr_callee

