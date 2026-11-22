
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *w_vector_max_size(w_vector_t *v)
;
; Return the vector's max_size in words.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC asm_w_vector_max_size

EXTERN l_readword_2_hl

defc asm_w_vector_max_size = l_readword_2_hl - 6

   ; enter : hl = vector *
   ;
   ; exit  : hl = vector.max_size in words
   ;
   ; uses  : a, hl
