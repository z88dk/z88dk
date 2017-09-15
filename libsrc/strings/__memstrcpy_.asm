; char *_memstrcpy_(void *p, char *s, size_t n)

SECTION code_clib
SECTION code_string

MODULE __memstrcpy__sdcc
GLOBAL __memstrcpy_
GLOBAL _memstrcpy_

defc __memstrcpy_ = _memstrcpy_

