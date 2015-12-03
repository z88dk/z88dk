
; char *strtok_r(char * restrict s, const char * restrict sep, char ** restrict lasts)

SECTION code_clib
SECTION code_string

PUBLIC strtok_r

EXTERN asm_strtok_r

strtok_r:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_strtok_r
