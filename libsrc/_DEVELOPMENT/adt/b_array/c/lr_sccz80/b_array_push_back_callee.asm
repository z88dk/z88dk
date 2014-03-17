
; size_t b_array_push_back(b_array_t *a, int c)

XDEF b_array_push_back_callee

b_array_push_back_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "../../z80/asm_b_array_push_back.asm"
