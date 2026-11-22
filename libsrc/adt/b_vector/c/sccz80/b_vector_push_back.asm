
; size_t b_vector_push_back(b_vector_t *v, int c)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_push_back

EXTERN b_vector_append

defc b_vector_push_back = b_vector_append

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_vector_push_back
defc _b_vector_push_back = b_vector_push_back
ENDIF

