
; void *p_list_back(p_list_t *list)

SECTION code_adt_p_list

PUBLIC _p_list_back

_p_list_back:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/p_list/z80/asm_p_list_back.asm"
