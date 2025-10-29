
; int ffs(int i)

SECTION code_clib
SECTION code_string

PUBLIC _ffs

EXTERN asm_ffs

_ffs:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_ffs
