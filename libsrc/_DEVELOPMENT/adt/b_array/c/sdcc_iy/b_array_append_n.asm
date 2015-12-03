
; size_t b_array_append_n(b_array_t *a, size_t n, int c)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_append_n

EXTERN asm_b_array_append_n

_b_array_append_n:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm_b_array_append_n
