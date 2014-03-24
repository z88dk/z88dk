
; char *strtok_r(char * restrict s, const char * restrict sep, char ** restrict lasts)

XDEF strtok_r

strtok_r:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   INCLUDE "string/z80/asm_strtok_r.asm"
