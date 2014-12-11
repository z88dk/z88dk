
; void *p_forward_list_alt_pop_back(p_forward_list_alt_t *list)

SECTION code_adt_p_forward_list_alt

PUBLIC _p_forward_list_alt_pop_back

_p_forward_list_alt_pop_back:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_pop_back.asm"
