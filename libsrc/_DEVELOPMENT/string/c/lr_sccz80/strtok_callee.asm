
; char *strtok(char * restrict s1, const char * restrict s2)

XDEF strtok_callee

strtok_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "../../z80/asm_strtok.asm"
