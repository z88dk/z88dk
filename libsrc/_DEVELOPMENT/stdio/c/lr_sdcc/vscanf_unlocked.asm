
; int vscanf_unlocked(const char *format, void *arg)

XDEF vscanf_unlocked

vscanf_unlocked:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   push ix
   
   call asm_vscanf_unlocked
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_vscanf_unlocked.asm"
