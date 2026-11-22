
; size_t b_array_insert_n(b_array_t *a, size_t idx, size_t n, int c)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_insert_n

EXTERN l0_b_array_insert_n_callee

_b_array_insert_n:

   pop af
   pop hl
   pop bc
   pop de
   exx
   pop bc
   
   push bc
   push de
   push bc
   push hl
   push af

   jp l0_b_array_insert_n_callee
