
; size_t b_array_insert_n(b_array_t *a, size_t idx, size_t n, int c)

PUBLIC b_array_insert_n

EXTERN asm_b_array_insert_n

b_array_insert_n:

   pop af
   pop ix
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push ix
   push af
   
   ld a,ixl
   jp asm_b_array_insert_n
