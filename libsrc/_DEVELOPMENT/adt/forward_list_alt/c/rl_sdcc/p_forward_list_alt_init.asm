
; void p_forward_list_alt_init(void *p)

XDEF p_forward_list_alt_init
XDEF p_forward_list_alt_clear
XDEF p_queue_init, p_queue_clear

p_forward_list_alt_init:
p_forward_list_alt_clear:
p_queue_init:
p_queue_clear:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_p_forward_list_alt_init.asm"
