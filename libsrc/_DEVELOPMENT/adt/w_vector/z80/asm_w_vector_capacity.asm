
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_W_VECTOR_MAX_SIZE

; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t w_vector_capacity(w_vector_t *v)
;
; Return the amount of space allocated for the vector's array.
;
; ===============================================================

asm_b_vector_capacity:

   ; enter : hl = w_vector_t *v
   ;
   ; exit  : hl = capacity in words
   ;
   ; uses  : a, hl
