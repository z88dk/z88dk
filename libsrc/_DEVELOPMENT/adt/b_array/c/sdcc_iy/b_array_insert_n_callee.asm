
; size_t b_array_insert_n_callee(b_array_t *a, size_t idx, size_t n, int c)

SECTION code_adt_b_array

PUBLIC _b_array_insert_n_callee, l0_b_array_insert_n_callee

_b_array_insert_n_callee:

   pop af
   pop hl
   pop bc
   pop de
   exx
   pop bc
   push af
   
l0_b_array_insert_n_callee:

   ld a,c
   exx
   
   INCLUDE "adt/b_array/z80/asm_b_array_insert_n.asm"
