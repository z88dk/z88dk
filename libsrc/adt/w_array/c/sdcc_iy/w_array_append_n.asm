
; size_t w_array_append_n(w_array_t *a, size_t n, void *item)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_append_n

EXTERN asm_w_array_append_n

_w_array_append_n:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm_w_array_append_n
