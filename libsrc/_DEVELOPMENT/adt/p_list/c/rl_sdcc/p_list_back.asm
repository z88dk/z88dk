
; void *p_list_back(p_list_t *list)

XDEF p_list_back

p_list_back:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_p_list_back

   INCLUDE "../../z80/asm_p_list_back.asm"
