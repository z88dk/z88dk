
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t b_vector_max_size(b_vector_t *v)
;
; Return the vector's max_size.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_max_size

EXTERN l_readword_hl

defc asm_b_vector_max_size = l_readword_hl - 6

   ; enter : hl = b_vector_t *
   ;
   ; exit  : hl = max_size
   ;
   ; uses  : a, hl
