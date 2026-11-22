
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *w_vector_data(w_vector_t *v)
;
; Return the address of the vector's array, might be 0.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC asm_w_vector_data

EXTERN l_readword_hl

defc asm_w_vector_data = l_readword_hl

   ; enter : hl = vector *
   ;
   ; exit  : hl = vector.data
   ;
   ; uses  : a, hl
