
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t w_vector_size(w_vector_t *v)
;
; Return the vector's current size.
;
; ===============================================================

PUBLIC asm_w_vector_size

EXTERN l_readword_2_hl

asm_w_vector_size:

   jp l_readword_2_hl - 2

;defc asm_w_vector_size = l_readword_2_hl - 2

   ; enter : hl = vector *
   ;
   ; exit  : hl = size in words
   ;
   ; uses  : a, hl
