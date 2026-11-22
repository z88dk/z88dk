
; b_array_t *b_array_init_callee(void *p, void *data, size_t capacity)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_init_callee

EXTERN asm_b_array_init

_b_array_init_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   jp asm_b_array_init
