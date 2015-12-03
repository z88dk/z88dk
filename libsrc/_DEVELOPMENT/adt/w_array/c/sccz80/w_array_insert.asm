
; size_t w_array_insert(w_array_t *a, size_t idx, void *item)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_insert

EXTERN asm_w_array_insert

w_array_insert:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   jp asm_w_array_insert
