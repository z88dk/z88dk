
; size_t b_array_append(b_array_t *a, int c)

XDEF b_array_append_callee

b_array_append_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "../../z80/asm_b_array_append.asm"
