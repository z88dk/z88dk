
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_B_ARRAY_CAPACITY

; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_vector_size(b_vector_t *v)
;
; Return the vector's current size.
;
; ===============================================================

asm_b_vector_size:

   ; enter : hl = vector *
   ;
   ; exit  : hl = size
   ;
   ; uses  : a, hl
