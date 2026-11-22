
; void *b_vector_insert_block(b_vector_t *v, size_t idx, size_t n)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_insert_block_callee

EXTERN asm_b_vector_insert_block

b_vector_insert_block_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_b_vector_insert_block

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_vector_insert_block_callee
defc _b_vector_insert_block_callee = b_vector_insert_block_callee
ENDIF

