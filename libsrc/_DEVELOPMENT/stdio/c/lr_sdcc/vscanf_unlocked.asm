
; int vscanf_unlocked(const char *format, void *arg)

XDEF vscanf_unlocked

vscanf_unlocked:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   INCLUDE "../../z80/asm_vscanf_unlocked.asm"
