
; void *p_list_push_front_callee(p_list_t *list, void *item)

SECTION code_adt_p_list

PUBLIC _p_list_push_front_callee

_p_list_push_front_callee:

   pop af
   pop hl
   pop de
   push af

   INCLUDE "adt/p_list/z80/asm_p_list_push_front.asm"
