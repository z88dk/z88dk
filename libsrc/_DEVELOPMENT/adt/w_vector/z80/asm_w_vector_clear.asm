
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void w_vector_clear(w_vector_t *v)
;
; Clear the vector to empty.
;
; ===============================================================

XLIB asm_w_vector_clear

LIB l_zeroword_hl

defc asm_w_vector_clear = l_zeroword_hl - 2

   ; enter : hl = vector *
   ;
   ; exit  : hl = & vector.size
   ;
   ; uses  : hl
