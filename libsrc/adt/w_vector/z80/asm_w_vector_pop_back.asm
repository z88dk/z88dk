
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *w_vector_pop_back(w_vector_t *v)
;
; Pop word from end of vector.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC asm_w_vector_pop_back

EXTERN asm_w_array_pop_back

defc asm_w_vector_pop_back = asm_w_array_pop_back

   ; enter : hl = vector *
   ;
   ; exit  : success
   ;
   ;            hl = last word, popped
   ;            carry reset
   ;
   ;         fail if vector is empty
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
