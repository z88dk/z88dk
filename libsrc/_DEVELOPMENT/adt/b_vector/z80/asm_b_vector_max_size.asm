
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *b_vector_max_size(b_vector_t *v)
;
; Return the vector's max_size.
;
; ===============================================================

XLIB asm_b_vector_max_size

LIB l_readword_hl

defc asm_b_vector_max_size = l_readword_hl - 6

   ; enter : hl = b_vector_t *
   ;
   ; exit  : hl = max_size
   ;
   ; uses  : a, hl
