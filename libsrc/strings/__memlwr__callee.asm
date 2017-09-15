; char *_memlwr_(void *p, size_t n)

SECTION code_clib
SECTION code_string

MODULE __memlwr__callee_sdcc
GLOBAL __memlwr__callee
GLOBAL _memlwr__callee

defc __memlwr__callee = _memlwr__callee

