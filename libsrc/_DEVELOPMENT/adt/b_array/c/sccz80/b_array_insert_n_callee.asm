
; size_t b_array_insert_n(b_array_t *a, size_t idx, size_t n, int c)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_insert_n_callee

EXTERN asm_b_array_insert_n

b_array_insert_n_callee:

   pop hl
   pop de
   ld a,e
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_b_array_insert_n
