
; int system(const char *string)

PUBLIC _system

_system:

   pop af
   pop hl
   
   push hl
   push af
   
   push iy
   
   call asm_system
   
   pop iy
   ret

   INCLUDE "stdlib/z80/asm_system.asm"
