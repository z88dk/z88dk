
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_B_ARRAY_CAPACITY

; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *w_vector_data(w_vector_t *v)
;
; Return the address of the vector's array, might be 0.
;
; ===============================================================

asm_w_vector_data:

   ; enter : hl = vector *
   ;
   ; exit  : hl = vector.data
   ;
   ; uses  : a, hl
