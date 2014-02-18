
; void p_forward_list_init(void *p)

XDEF p_forward_list_init
XDEF p_forward_list_clear, p_stack_init, p_stack_clear

p_forward_list_init:
p_forward_list_clear:
p_stack_init:
p_stack_clear:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_p_forward_list_init.asm"
