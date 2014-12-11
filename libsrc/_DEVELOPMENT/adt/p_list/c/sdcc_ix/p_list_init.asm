
; void p_list_init(void *p)

SECTION code_adt_p_list

PUBLIC _p_list_init

_p_list_init:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "adt/p_list/z80/asm_p_list_init.asm"
