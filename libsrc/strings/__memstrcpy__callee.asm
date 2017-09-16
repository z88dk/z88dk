; char *_memstrcpy_(void *p, char *s, size_t n)

SECTION code_clib
SECTION code_string

MODULE __memstrcpy__callee_sdcc
GLOBAL __memstrcpy__callee
GLOBAL _memstrcpy__callee

defc __memstrcpy__callee = _memstrcpy__callee

