; BSD
; void *rawmemchr(const void *mem, int c)

SECTION code_clib
SECTION code_string

MODULE _rawmemchr_sdcc
GLOBAL _rawmemchr
GLOBAL rawmemchr

defc _rawmemchr = rawmemchr

