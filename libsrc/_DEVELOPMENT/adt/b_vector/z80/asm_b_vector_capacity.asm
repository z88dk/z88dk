
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_vector_capacity(b_vector_t *v)
;
; Return the amount of space allocated for vector.data.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_capacity

EXTERN l_readword_hl

defc asm_b_vector_capacity = l_readword_hl - 4

   ; enter : hl = vector *
   ;
   ; exit  : hl = capacity in bytes
   ;
   ; uses  : a, hl
