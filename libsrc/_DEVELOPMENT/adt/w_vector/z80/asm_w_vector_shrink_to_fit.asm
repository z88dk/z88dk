
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_B_VECTOR_SHRINK_TO_FIT

; ===============================================================
; Feb 2014
; ===============================================================
; 
; int w_vector_shrink_to_fit(w_vector_t *v)
;
; Release any excess memory allocated for the vector's array.
;
; After calling, vector.capacity == vector.size
;
; ===============================================================

asm_w_vector_shrink_to_fit:

   ; enter : hl = w_vector_t *
   ;
   ; exit  : success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail on realloc not getting lock
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl
