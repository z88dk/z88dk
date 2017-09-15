; char *_memupr_(void *p, size_t n)

SECTION code_clib
SECTION code_string

MODULE __memupr__sdcc
GLOBAL __memupr_
GLOBAL _memupr_

defc __memupr_ = _memupr_

