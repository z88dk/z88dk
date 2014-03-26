
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t b_vector_max_size(b_vector_t *v)
;
; Return the vector's max_size.
;
; ===============================================================

XLIB asm_b_vector_max_size

LIB l_readword_hl

asm_b_vector_max_size:

   jp l_readword_hl - 6

;defc asm_b_vector_max_size = l_readword_hl - 6

   ; enter : hl = b_vector_t *
   ;
   ; exit  : hl = max_size
   ;
   ; uses  : a, hl
