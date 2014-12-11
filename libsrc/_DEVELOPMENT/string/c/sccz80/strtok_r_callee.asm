
; char *strtok_r(char * restrict s, const char * restrict sep, char ** restrict lasts)

SECTION code_string

PUBLIC strtok_r_callee

strtok_r_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "string/z80/asm_strtok_r.asm"
