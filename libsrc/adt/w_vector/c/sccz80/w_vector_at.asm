
; void *w_vector_at(b_vector_t *v, size_t idx)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_at

EXTERN w_array_at

defc w_vector_at = w_array_at

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _w_vector_at
defc _w_vector_at = w_vector_at
ENDIF

