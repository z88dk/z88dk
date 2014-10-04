
; void *p_forward_list_back(p_forward_list_t *list)

SECTION seg_code_p_forward_list

PUBLIC _p_forward_list_back

_p_forward_list_back:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_back.asm"
