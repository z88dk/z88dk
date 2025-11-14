
; char *strupr(char *s)

SECTION code_clib
SECTION code_string

PUBLIC _strupr

EXTERN asm_strupr

_strupr:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_strupr
