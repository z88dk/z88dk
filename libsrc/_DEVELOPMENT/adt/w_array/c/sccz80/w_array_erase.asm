
; size_t w_array_erase(w_array_t *a, size_t idx)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_erase

EXTERN asm_w_array_erase

w_array_erase:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_w_array_erase
