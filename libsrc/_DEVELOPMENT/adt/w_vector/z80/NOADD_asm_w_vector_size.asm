
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_W_ARRAY_CAPACITY

; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t w_vector_size(w_vector_t *v)
;
; Return the vector's current size.
;
; ===============================================================

asm_w_vector_size:

   ; enter : hl = vector *
   ;
   ; exit  : hl = size in words
   ;
   ; uses  : a, hl
