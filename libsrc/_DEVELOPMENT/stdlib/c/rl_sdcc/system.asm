
; int system(const char *string)

XDEF system

system:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "../../z80/asm_system.asm"
