
; int getchar(void)

XDEF getchar

getchar:

   push ix
   
   call asm_getchar
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_getchar.asm"
