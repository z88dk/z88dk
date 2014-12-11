
; int b_array_resize(b_array_t *a, size_t n)

SECTION code_adt_b_array

PUBLIC b_array_resize_callee

b_array_resize_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "adt/b_array/z80/asm_b_array_resize.asm"
