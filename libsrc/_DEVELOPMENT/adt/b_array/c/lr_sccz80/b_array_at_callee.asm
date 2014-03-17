
; int b_array_at(b_array_t *a, size_t idx)

XDEF b_array_at_callee

b_array_at_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "../../z80/asm_b_array_at.asm"
