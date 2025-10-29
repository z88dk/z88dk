
; size_t w_array_append(w_array_t *a, void *item)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_append

EXTERN asm_w_array_append

_w_array_append:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_w_array_append
