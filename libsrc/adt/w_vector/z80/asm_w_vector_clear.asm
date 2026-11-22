
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void w_vector_clear(w_vector_t *v)
;
; Clear the vector to empty.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC asm_w_vector_clear

EXTERN l_zeroword_hl

defc asm_w_vector_clear = l_zeroword_hl - 2

   ; enter : hl = vector *
   ;
   ; exit  : hl = & vector.size
   ;
   ; uses  : hl
