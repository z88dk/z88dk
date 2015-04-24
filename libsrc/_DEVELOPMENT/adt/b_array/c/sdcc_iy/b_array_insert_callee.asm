
; size_t b_array_insert_callee(b_array_t *a, size_t idx, int c)

SECTION code_adt_b_array

PUBLIC _b_array_insert_callee

_b_array_insert_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "adt/b_array/z80/asm_b_array_insert.asm"
