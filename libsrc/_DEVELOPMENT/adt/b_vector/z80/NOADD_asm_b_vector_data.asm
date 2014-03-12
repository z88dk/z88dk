
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_B_ARRAY_CAPACITY

; ===============================================================
; Mar 2014
; ===============================================================
; 
; void *b_vector_data(b_vector_t *v)
;
; Return the address of the vector's data, could be 0.
;
; ===============================================================

asm_b_vector_data:

   ; enter : hl = vector *
   ;
   ; exit  : hl = vector.data
   ;
   ; uses  : a, hl
