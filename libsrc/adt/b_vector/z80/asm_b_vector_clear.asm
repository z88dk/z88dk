
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void b_vector_clear(b_vector_t *v)
;
; Clear the vector to empty.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC asm_b_vector_clear

EXTERN l_zeroword_hl

defc asm_b_vector_clear = l_zeroword_hl - 2

   ; enter : hl = vector *
   ;
   ; exit  : hl = & vector.size
   ;
   ; uses  : hl
