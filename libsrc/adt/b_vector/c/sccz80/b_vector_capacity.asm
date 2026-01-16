
; size_t b_vector_capacity(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_capacity

EXTERN asm_b_vector_capacity

defc b_vector_capacity = asm_b_vector_capacity

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_vector_capacity
defc _b_vector_capacity = b_vector_capacity
ENDIF

