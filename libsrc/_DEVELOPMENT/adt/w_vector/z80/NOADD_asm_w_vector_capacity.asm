
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_W_ARRAY_CAPACITY

; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t w_vector_capacity(w_vector_t *v)
;
; Return the amount of space allocated for the vector's array in words.
;
; ===============================================================

asm_w_vector_capacity:

   ; enter : hl = vector *v
   ;
   ; exit  : hl = capacity in words
   ;
   ; uses  : a, hl
