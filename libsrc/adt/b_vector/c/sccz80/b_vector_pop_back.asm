
; int b_vector_pop_back(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_pop_back

EXTERN asm_b_vector_pop_back

defc b_vector_pop_back = asm_b_vector_pop_back

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_vector_pop_back
defc _b_vector_pop_back = b_vector_pop_back
ENDIF

