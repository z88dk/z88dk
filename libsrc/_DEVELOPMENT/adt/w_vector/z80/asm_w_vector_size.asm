
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t w_vector_size(w_vector_t *v)
;
; Return the vector's current size.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC asm_w_vector_size

EXTERN l_readword_2_hl

defc asm_w_vector_size = l_readword_2_hl - 2

   ; enter : hl = vector *
   ;
   ; exit  : hl = size in words
   ;
   ; uses  : a, hl
