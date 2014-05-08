
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_vector_capacity(b_vector_t *v)
;
; Return the amount of space allocated for vector.data.
;
; ===============================================================

PUBLIC asm_b_vector_capacity

EXTERN l_readword_hl

asm_b_vector_capacity:

   jp l_readword_hl - 4

;defc asm_b_vector_capacity = l_readword_hl - 4

   ; enter : hl = vector *
   ;
   ; exit  : hl = capacity in bytes
   ;
   ; uses  : a, hl
