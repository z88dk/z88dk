
; void *w_array_at(w_array_t *a, size_t idx)

XDEF w_array_at_callee

w_array_at_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "../../z80/asm_w_array_at.asm"
