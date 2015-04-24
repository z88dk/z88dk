
; size_t b_array_append_callee(b_array_t *a, int c)

SECTION code_adt_b_array

PUBLIC _b_array_append_callee

_b_array_append_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "adt/b_array/z80/asm_b_array_append.asm"
