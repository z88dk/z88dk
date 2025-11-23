
; int b_vector_back(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_back

EXTERN b_array_back

defc b_vector_back = b_array_back

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_vector_back
defc _b_vector_back = b_vector_back
ENDIF

