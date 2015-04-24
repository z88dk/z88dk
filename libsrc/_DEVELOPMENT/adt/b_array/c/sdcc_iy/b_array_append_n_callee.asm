
; size_t b_array_append_n_callee(b_array_t *a, size_t n, int c)

SECTION code_adt_b_array

PUBLIC _b_array_append_n_callee

_b_array_append_n_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   INCLUDE "adt/b_array/z80/asm_b_array_append_n.asm"
