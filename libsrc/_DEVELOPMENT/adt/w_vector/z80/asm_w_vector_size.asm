
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_W_VECTOR_MAX_SIZE

; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *w_vector_size(w_vector_t *v)
;
; Return the vector's current size.
;
; ===============================================================

asm_w_vector_size:

   ; enter : hl = w_vector_t *
   ;
   ; exit  : hl = size in words
   ;
   ; uses  : a, hl
