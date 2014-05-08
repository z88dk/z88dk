
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void b_vector_clear(b_vector_t *v)
;
; Clear the vector to empty.
;
; ===============================================================

PUBLIC asm_b_vector_clear

EXTERN l_zeroword_hl

asm_b_vector_clear:

   jp l_zeroword_hl - 2

;defc asm_b_vector_clear = l_zeroword_hl - 2

   ; enter : hl = vector *
   ;
   ; exit  : hl = & vector.size
   ;
   ; uses  : hl
