
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_vector_size(b_vector_t *v)
;
; Return the vector's current size.
;
; ===============================================================

XLIB asm_b_vector_size

LIB l_readword_hl

asm_b_vector_size:

   jp l_readword_hl - 2

;defc asm_b_vector_size = l_readword_hl - 2

   ; enter : hl = vector *
   ;
   ; exit  : hl = size
   ;
   ; uses  : a, hl
