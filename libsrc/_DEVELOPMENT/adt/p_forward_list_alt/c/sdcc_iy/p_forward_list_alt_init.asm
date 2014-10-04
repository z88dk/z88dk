
; void p_forward_list_alt_init(void *p)

SECTION seg_code_p_forward_list_alt

PUBLIC _p_forward_list_alt_init

_p_forward_list_alt_init:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_init.asm"
