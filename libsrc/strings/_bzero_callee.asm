; BSD
; void bzero(void *mem, int bytes)

SECTION code_clib
SECTION code_string

MODULE _bzero_callee_sdcc
GLOBAL _bzero_callee
GLOBAL bzero_callee

defc _bzero_callee = bzero_callee

