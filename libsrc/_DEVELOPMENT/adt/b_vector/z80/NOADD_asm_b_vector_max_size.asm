
*** IMPLEMENTED AS PART OF ASM_B_ARRAY_CAPACITY

; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *b_vector_max_size(b_vector_t *v)
;
; Return the vector's max_size.
;
; ===============================================================

asm_b_vector_max_size:

   ; enter : hl = b_vector_t *
   ;
   ; exit  : hl = max_size
   ;
   ; uses  : a, hl
