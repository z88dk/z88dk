
; size_t w_vector_push_back(w_vector_t *v, int c)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_push_back

EXTERN w_vector_append

defc w_vector_push_back = w_vector_append

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _w_vector_push_back
defc _w_vector_push_back = w_vector_push_back
ENDIF

