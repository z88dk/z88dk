
; size_t w_array_erase(w_array_t *a, size_t idx)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_erase

EXTERN asm_w_array_erase

_w_array_erase:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_w_array_erase
