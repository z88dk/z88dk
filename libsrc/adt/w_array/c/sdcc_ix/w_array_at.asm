
; void *w_array_at(w_array_t *a, size_t idx)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_at

EXTERN asm_w_array_at

_w_array_at:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_w_array_at
