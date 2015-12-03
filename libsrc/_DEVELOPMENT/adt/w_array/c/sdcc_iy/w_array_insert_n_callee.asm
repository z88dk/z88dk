
; size_t w_array_insert_n_callee(w_array_t *a, size_t idx, size_t n, void *item)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_insert_n_callee

EXTERN asm_w_array_insert_n

_w_array_insert_n_callee:

   pop ix
   pop hl
   pop bc
   pop de
   pop af
   push ix
      
   jp asm_w_array_insert_n
