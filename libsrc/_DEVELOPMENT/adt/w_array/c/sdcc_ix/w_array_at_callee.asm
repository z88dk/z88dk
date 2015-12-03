
; void *w_array_at_callee(w_array_t *a, size_t idx)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_at_callee

EXTERN asm_w_array_at

_w_array_at_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_w_array_at
