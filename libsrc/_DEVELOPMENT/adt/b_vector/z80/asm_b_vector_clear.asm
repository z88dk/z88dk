
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void b_vector_clear(b_vector_t *v)
;
; Clear the vector to empty.
;
; ===============================================================

XLIB asm_b_vector_clear

LIB l_zeroword_hl

defc asm_b_vector_clear = l_zeroword_hl - 2

   ; enter : hl = vector *
   ;
   ; exit  : hl = & vector.size
   ;
   ; uses  : hl
