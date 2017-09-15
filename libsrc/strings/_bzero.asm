; BSD
; void bzero(void *mem, int bytes)

SECTION code_clib
SECTION code_string

MODULE _bzero_sdcc
GLOBAL _bzero
GLOBAL bzero

defc _bzero = bzero

