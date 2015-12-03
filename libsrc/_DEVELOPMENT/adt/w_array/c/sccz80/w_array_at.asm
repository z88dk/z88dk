
; void *w_array_at(w_array_t *a, size_t idx)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_at

EXTERN asm_w_array_at

w_array_at:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_w_array_at
