
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

PUBLIC asm_w_vector_shrink_to_fit

EXTERN asm_b_vector_shrink_to_fit

asm_w_vector_shrink_to_fit:

   jp asm_b_vector_shrink_to_fit

;defc asm_w_vector_shrink_to_fit = asm_b_vector_shrink_to_fit

   ; enter : hl = vector *
   ;
   ; exit  : success
   ;
   ;            hl = -1
   ;            carry reset
   ;
   ;         fail on realloc not getting lock
   ;
   ;            hl = 0
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl
