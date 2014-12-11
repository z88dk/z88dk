
; size_t b_array_append(b_array_t *a, int c)

SECTION code_adt_b_array

PUBLIC b_array_append_callee

b_array_append_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/b_array/z80/asm_b_array_append.asm"
