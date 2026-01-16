
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void *b_vector_data(b_vector_t *v)
;
; Return the address of the vector's data, could be 0.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_data

EXTERN l_readword_hl

defc asm_b_vector_data = l_readword_hl

   ; enter : hl = vector *
   ;
   ; exit  : hl = vector.data
   ;
   ; uses  : a, hl
