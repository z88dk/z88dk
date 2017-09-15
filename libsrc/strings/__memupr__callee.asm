; char *_memupr_(void *p, size_t n)

SECTION code_clib
SECTION code_string

MODULE __memupr__callee_sdcc
GLOBAL __memupr__callee
GLOBAL _memupr__callee

defc __memupr__callee = _memupr__callee

