
*** IMPLEMENTED AS PART OF ASM_B_ARRAY_CAPACITY

; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_vector_capacity(b_vector_t *v)
;
; Return the amount of space allocated for vector.data.
;
; ===============================================================

asm_b_vector_capacity:

   ; enter : hl = vector *
   ;
   ; exit  : hl = capacity in bytes
   ;
   ; uses  : a, hl
