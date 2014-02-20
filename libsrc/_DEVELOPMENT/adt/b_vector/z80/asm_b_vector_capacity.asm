
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_B_VECTOR_MAX_SIZE

; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t b_vector_capacity(b_vector_t *v)
;
; Return the amount of space allocated for the vector's array.
;
; ===============================================================

asm_b_vector_capacity:

   ; enter : hl = b_vector_t *v
   ;
   ; exit  : hl = capacity in bytes
   ;
   ; uses  : a, hl
