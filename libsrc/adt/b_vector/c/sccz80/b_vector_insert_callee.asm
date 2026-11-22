
; size_t b_vector_insert(b_vector_t *v, size_t idx, int c)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_insert_callee

EXTERN asm_b_vector_insert

b_vector_insert_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_b_vector_insert

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_vector_insert_callee
defc _b_vector_insert_callee = b_vector_insert_callee
ENDIF

