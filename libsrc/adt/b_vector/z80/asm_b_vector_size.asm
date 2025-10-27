
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_vector_size(b_vector_t *v)
;
; Return the vector's current size.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_size

EXTERN l_readword_hl

defc asm_b_vector_size = l_readword_hl - 2

   ; enter : hl = vector *
   ;
   ; exit  : hl = size
   ;
   ; uses  : a, hl
