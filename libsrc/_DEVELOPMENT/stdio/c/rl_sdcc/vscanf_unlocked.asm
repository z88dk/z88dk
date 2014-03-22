
; int vscanf_unlocked(const char *format, void *arg)

XDEF vscanf_unlocked

vscanf_unlocked:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   push ix
   
   call asm_vscanf_unlocked
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_vscanf_unlocked.asm"
