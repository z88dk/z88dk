
; size_t w_array_insert(w_array_t *a, size_t idx, void *item)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_insert

EXTERN asm_w_array_insert

_w_array_insert:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   jp asm_w_array_insert
