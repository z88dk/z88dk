
; size_t w_array_insert_callee(w_array_t *a, size_t idx, void *item)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_insert_callee

EXTERN asm_w_array_insert

_w_array_insert_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   jp asm_w_array_insert
