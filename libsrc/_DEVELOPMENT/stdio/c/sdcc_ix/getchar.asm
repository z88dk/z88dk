
; int getchar(void)

XDEF _getchar

_getchar:

   push ix
   
   call asm_getchar
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_getchar.asm"
