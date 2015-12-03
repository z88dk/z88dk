
; char *strtok_r(char * restrict s, const char * restrict sep, char ** restrict lasts)

SECTION code_clib
SECTION code_string

PUBLIC strtok_r_callee

EXTERN asm_strtok_r

strtok_r_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_strtok_r
