
; void *w_array_front(w_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_front

EXTERN asm_w_array_front

_w_array_front:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_w_array_front
