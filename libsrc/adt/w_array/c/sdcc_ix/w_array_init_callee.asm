
; w_array_t *w_array_init_callee(void *p, void *data, size_t capacity)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_init_callee

EXTERN asm_w_array_init

_w_array_init_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   jp asm_w_array_init
