
; int system(const char *string)

XDEF system

system:

   pop af
   pop hl
   
   push hl
   push af
   
   push iy
   
   call asm_system
   
   pop iy
   ret

   INCLUDE "stdlib/z80/asm_system.asm"
