
; size_t w_array_capacity(w_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_capacity

EXTERN asm_w_array_capacity

_w_array_capacity:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_w_array_capacity
