
; int b_vector_reserve(b_vector_t *v, size_t n)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_reserve_callee

EXTERN asm_b_vector_reserve

b_vector_reserve_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_b_vector_reserve

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_vector_reserve_callee
defc _b_vector_reserve_callee = b_vector_reserve_callee
ENDIF

