
; size_t b_array_erase(b_array_t *a, size_t idx)

XDEF b_array_erase_callee

b_array_erase_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/b_array/z80/asm_b_array_erase.asm"
