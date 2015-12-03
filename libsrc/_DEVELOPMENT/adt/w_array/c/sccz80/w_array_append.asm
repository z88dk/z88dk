
; size_t w_array_append(w_array_t *a, void *item)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_append

EXTERN asm_w_array_append

w_array_append:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_w_array_append
