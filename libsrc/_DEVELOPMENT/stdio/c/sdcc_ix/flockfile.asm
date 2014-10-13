
; void flockfile(FILE *file)

SECTION seg_code_stdio

PUBLIC _flockfile

_flockfile:

   pop af
   pop bc
   
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_flockfile
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_flockfile.asm"
