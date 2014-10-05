
; char *strtok_r(char * restrict s, const char * restrict sep, char ** restrict lasts)

SECTION seg_code_string

PUBLIC _strtok_r

_strtok_r:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "string/z80/asm_strtok_r.asm"
