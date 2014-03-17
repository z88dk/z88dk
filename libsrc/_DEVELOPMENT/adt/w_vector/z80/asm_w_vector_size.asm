
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t w_vector_size(w_vector_t *v)
;
; Return the vector's current size.
;
; ===============================================================

XLIB asm_w_vector_size

LIB l_readword_2_hl

defc asm_w_vector_size = l_readword_2_hl - 2

   ; enter : hl = vector *
   ;
   ; exit  : hl = size in words
   ;
   ; uses  : a, hl
