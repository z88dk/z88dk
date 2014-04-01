
; int system(const char *string)

XDEF system

system:

   pop af
   pop hl
   
   push hl
   push af
   
   push ix
   
   call asm_system
   
   pop ix
   ret

   INCLUDE "stdlib/z80/asm_system.asm"
