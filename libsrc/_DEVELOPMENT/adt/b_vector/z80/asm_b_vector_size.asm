
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_B_VECTOR_MAX_SIZE

; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *b_vector_size(b_vector_t *v)
;
; Return the vector's current size.
;
; ===============================================================

asm_b_vector_size:

   ; enter : hl = b_vector_t *
   ;
   ; exit  : hl = size
   ;
   ; uses  : a, hl
