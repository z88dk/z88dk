
; size_t w_array_insert_n_callee(w_array_t *a, size_t idx, size_t n, void *item)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_insert_n_callee, l0_w_array_insert_n_callee

EXTERN asm_w_array_insert_n

_w_array_insert_n_callee:

   exx
   pop bc
   exx
   pop hl
   pop bc
   pop de
   pop af

l0_w_array_insert_n_callee:

   exx
   push bc
   exx
   
   jp asm_w_array_insert_n
