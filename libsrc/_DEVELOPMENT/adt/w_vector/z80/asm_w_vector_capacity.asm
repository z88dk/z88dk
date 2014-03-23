
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t w_vector_capacity(w_vector_t *v)
;
; Return the amount of space allocated for the vector's array in words.
;
; ===============================================================

XLIB asm_w_vector_capacity

LIB l_readword_2_hl

asm_w_vector_capacity:

   jp l_readword_2_hl - 4

;defc asm_w_vector_capacity = l_readword_2_hl - 4

   ; enter : hl = vector *v
   ;
   ; exit  : hl = capacity in words
   ;
   ; uses  : a, hl
