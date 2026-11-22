
; size_t w_array_append_callee(w_array_t *a, void *item)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_append_callee

EXTERN asm_w_array_append

_w_array_append_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_w_array_append
