
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

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC asm_w_vector_shrink_to_fit

EXTERN asm_b_vector_shrink_to_fit

defc asm_w_vector_shrink_to_fit = asm_b_vector_shrink_to_fit

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
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
