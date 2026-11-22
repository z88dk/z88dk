
; int w_array_resize(w_array_t *a, size_t n)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_resize

EXTERN asm_w_array_resize

_w_array_resize:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_w_array_resize
