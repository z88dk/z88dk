
; void w_vector_empty(w_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_empty

EXTERN asm_w_vector_empty

defc w_vector_empty = asm_w_vector_empty

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _w_vector_empty
defc _w_vector_empty = w_vector_empty
ENDIF

