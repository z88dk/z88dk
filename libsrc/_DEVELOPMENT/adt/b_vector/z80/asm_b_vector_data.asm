
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_B_VECTOR_MAX_SIZE

; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *b_vector_data(b_vector_t *v)
;
; Return the address of the vector's array, might be 0.
;
; ===============================================================

asm_b_vector_data:

   ; enter : hl = b_vector_t *
   ;
   ; exit  : hl = void *array
   ;
   ; uses  : a, hl
