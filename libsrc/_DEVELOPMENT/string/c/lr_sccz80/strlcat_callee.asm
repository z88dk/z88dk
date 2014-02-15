
; size_t strlcat(char * restrict s1, const char * restrict s2, size_t n)

XDEF strlcat_callee

strlcat_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "../../z80/sm_strlcat.asm"
