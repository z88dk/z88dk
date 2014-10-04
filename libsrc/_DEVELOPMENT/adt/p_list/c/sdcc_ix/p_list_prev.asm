
; void *p_list_prev(void *item)

SECTION seg_code_p_list

PUBLIC _p_list_prev

_p_list_prev:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/p_list/z80/asm_p_list_prev.asm"
