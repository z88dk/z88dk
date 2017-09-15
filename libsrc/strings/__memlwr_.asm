; char *_memlwr_(void *p, size_t n)

SECTION code_clib
SECTION code_string

MODULE __memlwr__sdcc
GLOBAL __memlwr_
GLOBAL _memlwr_

defc __memlwr_ = _memlwr_

