
; void p_list_init(void *p)

XDEF p_list_init

p_list_init:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "../../z80/asm_p_list_init.asm"
