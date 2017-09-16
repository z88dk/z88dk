; char *strupr(char *s)

SECTION code_clib
SECTION code_string

MODULE _strupr_sdcc
GLOBAL _strupr
GLOBAL strupr

defc _strupr = strupr

