
*** IMPLEMENTED AS PART OF ASM_W_ARRAY_CAPACITY

; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *w_vector_max_size(w_vector_t *v)
;
; Return the vector's max_size in words.
;
; ===============================================================

asm_w_vector_max_size:

   ; enter : hl = vector *
   ;
   ; exit  : hl = vector.max_size in words
   ;
   ; uses  : a, hl
