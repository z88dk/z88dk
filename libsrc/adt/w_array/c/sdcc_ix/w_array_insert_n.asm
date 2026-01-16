
; size_t w_array_insert_n(w_array_t *a, size_t idx, size_t n, void *item)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_insert_n

EXTERN l0_w_array_insert_n_callee

_w_array_insert_n:

   exx
   pop bc
   exx
   pop hl
   pop bc
   pop de
   pop af
   
   push af
   push de
   push bc
   push hl

   jp l0_w_array_insert_n_callee
