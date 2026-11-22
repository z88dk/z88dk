
; size_t w_vector_insert_n(w_vector_t *v, size_t idx, size_t n, void *item)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_insert_n_callee

EXTERN asm_w_vector_insert_n

w_vector_insert_n_callee:

   exx
   pop hl
   exx
   pop af
   pop de
   pop bc
   pop hl
   exx
   push hl
   exx

   jp asm_w_vector_insert_n

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _w_vector_insert_n_callee
defc _w_vector_insert_n_callee = w_vector_insert_n_callee
ENDIF

