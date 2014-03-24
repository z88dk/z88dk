
; void p_forward_list_alt_init(void *p)

XDEF p_forward_list_alt_init

p_forward_list_alt_init:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_init.asm"
