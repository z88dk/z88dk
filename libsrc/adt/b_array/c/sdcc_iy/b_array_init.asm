
; b_array_t *b_array_init(void *p, void *data, size_t capacity)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_init

EXTERN asm_b_array_init

_b_array_init:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm_b_array_init
