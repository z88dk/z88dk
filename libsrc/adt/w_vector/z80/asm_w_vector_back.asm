
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *w_vector_back(w_vector_t *v)
;
; Return word stored at the end of the vector.
; If the vector is empty, return -1.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC asm_w_vector_back

EXTERN asm_w_array_back

defc asm_w_vector_back = asm_w_array_back

   ; enter : hl = vector *
   ;
   ; exit  : success
   ;
   ;            de = & last word in vector
   ;            hl = last word in vector
   ;            carry reset
   ;
   ;         fail if vector is empty
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
